//
//  EffectGroup.swift
//  TCA MVP
//
//  Created by Salvador on 3/25/25.
//

import Foundation

struct EffectGroup<A> {
    /// `Most` of the time, `effects` will be just one `Effect`.
    /// The preferred implementation remains an array to allow enough flexibility for when the previous statement doesn't hold true.
    let effects: [Effect<A>]
    let allEffectsCompletedAction: A? /// Represents the closest equivalent to a completion handler for the completion of all `effects`' tasks. Optional since not all `EffectGroup`s require or use it.
    var throwMode: ThrowMode<A> /// Decides which error-handling style is gonna be used.
    
    init(effects: [Effect<A>], throwMode: ThrowMode<A>, completionAction: A? = nil) {
        self.effects = effects
        self.allEffectsCompletedAction = completionAction
        self.throwMode = throwMode
    }
    
    // Convenience initializer for a single effect
    init(effect: Effect<A>, throwMode: ThrowMode<A>, completionAction: A? = nil) {
        self.effects = [effect]
        self.allEffectsCompletedAction = completionAction
        self.throwMode = throwMode
    }
}

/** `Effect`s model interactions with the "outside world":
 - When completed, these effects will reintroduce new actions into the `Store`.
 - They are of `asynchronous` nature as they depend on external systems.
 - Because `Effect`s are of `async` nature, this means certain considerations must be taken when unit testing. Testing `async` code can become truly cumbersome and add unnecessary complexity to an already laborious task, so the preferred way of testing a `Store`'s `Effect`s behavior is to simulate the response through sending its response's `Action` to the `Store`. This is still good news because it means we can take a look under the hood and check on intermediary states between the starting action and the sencondary one fired by the `Effect` after completion.
 */
struct Effect<A> { /// `A: Action type`
    let execute: () async throws -> A
    
    /// `R: Response type`
    init<R>(asyncWork: @escaping () async throws -> R, responseAction: @escaping (R) -> A) {
        /// `asyncWork` is captured this way within `execute` because it lets "`type-erase`" its return value, we only care about the `Action` to perform based on its response.
        execute = {
            let result = try await asyncWork()
            return responseAction(result)
        }
    }
}

/** None of these modes guarantee that the effects will complete in the same order they were introduced.
 - Associated values represent the default resulting `Action` to handle `Effects`' thrown errors.
 -  `Int` represents the count of unsent actions to the `Store` because an error was thrown.
 
 They describe how to handle `Effect`s when any of their `execute()` throws.
 - Do we allow all of them to update `State` while ignoring any thrown errors? (`none`)
 - Do we allow all of them to update `State` but still handle thrown errors? (`lenient`)
 - Do we stop at the first thrown error (handling it), but allow effects completed by then to update `State`? (`partial`)
 - Do we even allow `State` updates at all when there's any error at any point? (`absolute`)
 */
enum ThrowMode<A> {
    case none /// Thrown errors aren't handled. Useful when performing background work that shouldn't disrupt user experience when failing.
    case lenient((Error) -> A) /// Let all effects complete, even if they throw errors. This could be considered the "default" in `ThrowMode`.
    case partial((Error, Int) -> A) /// At first thrown error, stop remaning running effects (if any). However, effects that have already completed will not be undone, and their results will be added to current `State`.
    case absolute((Error, Int) -> A) /// Run actions only if none of the effects throw an error.
}
