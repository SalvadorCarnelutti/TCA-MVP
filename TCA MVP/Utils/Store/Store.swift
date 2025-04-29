//
//  Store.swift
//  TCA MVP
//
//  Created by Salvador on 3/25/25.
//

import Foundation

/**
 `SwiftUI` is a `declarative` paradigm in comparison to `UIKit`'s `imperative`. This means the architecture applied has to accommodate the way views get drawn and laid out to the user:
 - `UIKit` is a step-by-step procedure when it comes to `UIViewControllers`. User interaction updates are conveyed through incremental manual view changes and model updates. It's easy to leave views and models out of sync if not careful.
 - `SwiftUI` is state-driven. In other words, `View`s are a function of `State`: `f(State) = View`. Sync is guaranteed since views automatically update and redraw on each state change.
 
 Luckily, `JavaScript` already tackled this issue long before with `Redux`, and the same architecture considerations can be applied to `SwiftUI`.
 
 `Action`s are modeled as `Enum`s, since they represent a finite set of performable/ocurring events, for any given `Feature`.
 - They should be as descriptive as possible, illustrating the event rather than the result to observe:
    * So, for a `CounterFeature` when a user interacts with a button to increment the count, the action should be named `"incrementButtonTapped"` instead of `"incrementCount"`.
    * When a user arrives at a screen for the first time, it's common to fetch data to display. Instead of `"get<ModelName>"`, the action should be `"onViewDidLoad"` or `"screenLoaded"`.
    This distinction is important because `Action`s should describe what happened in the view rather than dictate how `State` should be updated.
    After all, whether using `UIKit` or `SwiftUI`, `View`s should be "dumb" and not manage business logic.
 
 - `Enum`s are flexible enough not only to model a domain of actions, but also subdomains of it: The domain can be modularized as much (or as little) as needed.
 - `Enum`s are also great representation of actions because they can hold on to `associated values` that can either feed into a new `State` or be used for dispatching new `Effect`s.
 - Finally, `Action`s should be scoped to their specific `Feature` implementation's namespace. Since each `Feature` will have its own `Action` enum, we want to avoid name conflicts throughout the codebase.
 */

/**
 A `Reducer` is a function that receives the current `State` and an `Action`, decides how to update the `State` if necessary, and returns the new `State`: `f(state, action) = newState`.
 
 `Reducer`s must always follow some specific rules:
 - They should only calculate the new `State` value based on the `State` and `Action` arguments.
 - They are not allowed to modify the existing `State`. Instead, they must make immutable updates, by copying the existing `State` and making changes to the copied values.
 - They must not do any asynchronous logic, calculate random values, or cause other `"side effects"`.
 */

/// For practical reasons, `Reducer` is defined as a protocol rather than a function in this `SwiftUI` implementation, allowing it to be scoped within a `Struct` and ensuring modularized responsibilities.
protocol ReducerProtocol {
    associatedtype FeatureState /// `State` is a reserved keyword, so for practical reasons `FeatureState` and `FeatureAction` are being used instead for `ReducerProtocol`.
    associatedtype FeatureAction
    
    func reduce(state: FeatureState, action: FeatureAction) -> ReducerResult<FeatureState, FeatureAction>
}

/// Handles state management: It's the middleman between `SwiftUI`'s `View`s and the `Feature`'s `State`, allowing views to subscribe to state changes and enabling them to mutate the current state when certain events or actions occur.
final class Store<State, Reducer: ReducerProtocol>: ObservableObject where Reducer.FeatureState == State {
    /**
     `State` is the source of truth for a `Feature`’s `View`s at any given moment in time.
     - It must be `read-only` and immutable outside the `Store`’s scope.
     - All of its properties must be `value types`, not `reference types`, to ensure proper change detection.
     
     `@Published` properties inside `ObservableObject`s only trigger updates when those properties themselves are replaced (reassigned).
     - `value types` always reflect changes accurately because they produce a new instance when modified.
     - `reference types` won't reflect changes accurately because they don't produce a new instance when modified.
     **/
    @Published private(set) var state: State
    private let reducer: Reducer /// Dictates how a `State` updates (If necessary), according to a series of possible incoming `Actions`s.
    
    init(state: State, reducer: Reducer) {
        self.state = state
        self.reducer = reducer
    }
    
    /// `Store`s must expose an interface for mutating its state; this is done exclusively through actions and cannot be done in any other way (Every state transition should be explicitly tied to an action.).
    /// Any and all `send` calls must be performed on the main thread since `View`s are observing `State`. When performing `async` work, remember to run the method on the `MainActor`.
    func send(_ action: Reducer.FeatureAction) {
        let reducerResult = reducer.reduce(state: state, action: action)
        state = reducerResult.newState
        
        if let effectGroup = reducerResult.effectGroup, effectGroup.effects.isNotEmpty {
            Task { await handleEffects(effectGroup) }
        }
    }
}

/**
 `Action`s that require communication with external systems involve tasks that introduce new actions to a `Store`. These are represented as `Effect`s.
 - A new `State` is always returned even if pending effects were included. Even though we'll wait on data from an external system, we might want to modify current `State` in the meantime, for example, to update a property that drives a spinner activity behavior.
 - Finally, `Effect`s can fire new `Effect`s. This could easily represent sequential requests where either:
    * We want to complete one request before proceeding with the next, even though none of them blocks the other.
    * One request depends on the result of the other.
 */
struct ReducerResult<State, Action> {
    let newState: State
    let effectGroup: EffectGroup<Action>? /// A `nil` `EffectGroup` means no `Effect`s are to be dispatched.
}

// Complex effect handling is tucked away from the main class definition to make the overall architecture less daunting for developers to read.
extension Store {
    private func handleEffects(_ effectGroup: EffectGroup<Reducer.FeatureAction>) async {
        let effects = effectGroup.effects
        
        switch effectGroup.throwMode {
        case .none: await handleEffectsWithTaskGroupNone(effects)
        case .lenient(let errorActionHandler): await handleEffectsWithTaskGroupLenient(effects, errorActionHandler: errorActionHandler)
        case .partial(let errorActionHandler): await handleEffectsWithThrowingTaskGroupPartial(effects, errorActionHandler: errorActionHandler)
        case .absolute(let errorActionHandler): await handleEffectsWithThrowingTaskGroupAbsolute(effects, errorActionHandler: errorActionHandler)
        }
        
        if let allEffectsCompletedAction = effectGroup.allEffectsCompletedAction {
            await MainActor.run { send(allEffectsCompletedAction) } /// The `completionAction` will be invoked for all `ThrowMode`s, regardless of whether an error was thrown or not.
        }
    }
    private func handleEffectsWithTaskGroupNone(_ effects: [Effect<Reducer.FeatureAction>]) async {
        /// If any task in the group throws an error, the group will still follow through with remaining tasks. No errors are thrown.
        await withTaskGroup(of: Reducer.FeatureAction?.self) { group in
            for effect in effects {
                group.addTask {
                    do {
                        let newAction = try await effect.execute()
                        return newAction
                    } catch {
                        return nil
                    }
                }
            }
            
            /// The group yields the result of each `effect.execute()` call in the order they finish (not necessarily in the order they were added).
            for await newAction in group.compactMap({ $0 }) {
                await MainActor.run { send(newAction) }
            }
        }
    }

    private func handleEffectsWithTaskGroupLenient(_ effects: [Effect<Reducer.FeatureAction>], errorActionHandler: ErrorActionHandler<Reducer.FeatureAction>) async {
        /// If any task in the group throws an error, the group will still follow through with remaining tasks. This means multiple errors can be thrown during execution.
        await withTaskGroup(of: Result<Reducer.FeatureAction, Error>.self) { group in
            for effect in effects {
                group.addTask {
                    do {
                        let newAction = try await effect.execute()
                        return .success(newAction)
                    } catch {
                        return .failure(error)
                    }
                }
            }
            
            /// The group yields the result of each `effect.execute()` call in the order they finish (not necessarily in the order they were added).
            for await result in group {
                switch result {
                case .success(let newAction):
                    await MainActor.run { send(newAction) }
                case .failure(let error):
                    let errorAction = errorActionHandler(error, 1)
                    await MainActor.run { send(errorAction) }
                }
            }
        }
    }
    
    private func handleEffectsWithThrowingTaskGroupPartial(_ effects: [Effect<Reducer.FeatureAction>], errorActionHandler: ErrorActionHandler<Reducer.FeatureAction>) async {
        /// If any task in the group throws an error, the group immediately cancels remaining tasks and propagates the error. This means that a single error is ever thrown (if any at all).
        /// However, tasks that have already completed will not be undone, and their results might have already been processed (`Store` will have made partial `State` updates).
        
        var actionsSent = 0
        
        do {
            try await withThrowingTaskGroup(of: Reducer.FeatureAction.self) { group in
                for effect in effects {
                    group.addTask { try await effect.execute() }
                }
                
                /// The group yields the result of each `effect.execute()` call in the order they finish (not necessarily in the order they were added).
                for try await newAction in group {
                    await MainActor.run { send(newAction) }
                    actionsSent += 1
                }
            }
        } catch { /// From a whole bunch of effects, only one will ever be handled (if any).
            let errorAction = errorActionHandler(error, effects.count - actionsSent)
            await MainActor.run { send(errorAction) }
        }
    }
    
    private func handleEffectsWithThrowingTaskGroupAbsolute(_ effects: [Effect<Reducer.FeatureAction>], errorActionHandler: ErrorActionHandler<Reducer.FeatureAction>) async {
        /// If any task in the group throws an error, the group immediately cancels remaining tasks and propagates the error. This means that a single error is ever thrown (if any at all).
        do {
            let successfulNewActions = try await withThrowingTaskGroup(of: Reducer.FeatureAction.self) { group -> [Reducer.FeatureAction] in
                for effect in effects {
                    group.addTask { try await effect.execute() }
                }
                
                /// Collect all results and process them only if all tasks complete successfully
                var newActions: [Reducer.FeatureAction] = []
                for try await action in group { newActions.append(action) }
                return newActions
            }

            /// Since `successfulActions` is processed after the `try await withThrowingTaskGroup` block, the `catch` block is triggered instead.
            for newAction in successfulNewActions {
                await MainActor.run { send(newAction) }
            }
        } catch { /// From a whole bunch of effects, only one will ever be handled (if any).
            let errorAction = errorActionHandler(error, effects.count)
            await MainActor.run { send(errorAction) }
        }
    }
}
