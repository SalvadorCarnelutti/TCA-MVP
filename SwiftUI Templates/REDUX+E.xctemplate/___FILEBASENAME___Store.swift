//
//  ___FILEHEADER___
//

import SwiftUI

// MARK: ACTION
struct ___VARIABLE_moduleName:identifier___ {
    enum Action {
        // case yourEffectAction
        // getModelResponse(model)
        case alertAction(AlertAction)
        case destinationAction(DestinationAction)
        
        enum DestinationAction {
            // case yourDestinationAction
            case destinationCompleted
        }
        
        enum AlertAction {
            case errorResponse(Error, Int)
            case alertCompleted
        }
    }
    
    enum Destination: Equatable {
        // case yourDestination
    }

    enum AlertDestination: Equatable {
        case alertPhoneCall(String)
        case login
    }
}

// MARK: REDUCER
struct ___VARIABLE_moduleName:identifier___Reducer: ReducerProtocol {
    @Dependency(\.___VARIABLE_moduleNameFirstLetterLowercased:identifier___.client) var client

    func reduce(state: ___VARIABLE_moduleName:identifier___State, action: ___VARIABLE_moduleName:identifier___.Action) -> ReducerResult<___VARIABLE_moduleName:identifier___State, ___VARIABLE_moduleName:identifier___.Action> {
        var newState = state
        var effectGroup: EffectGroup<___VARIABLE_moduleName:identifier___.Action>?
        
        switch action {
            // case .yourEffectAction:
            //     newState.activeRequests += 1
            //     effectGroup = EffectGroup(effect: Effect(asyncWork: client.getModel(),
            //                                              responseAction: { model in .getModelResponse(model) }),
            //                               throwMode: .lenient(onErrorAction))
            // case .getModelResponse(model)...
        case .alertAction(let alertAction):
            switch alertAction {
            case .errorResponse(let error, let unsentActionsCount):
                newState.reduxAlert = .error
                newState.activeRequests -= unsentActionsCount
            case .alertCompleted:
                newState.reduxAlert = nil
            }
        case .destinationAction(let destinationAction):
            switch destinationAction {
            // case .yourDestinationAction...
            case .destinationCompleted:
                newState.destination = nil
            }
        }

        return ReducerResult(newState: newState, effectGroup: effectGroup)
    }
    
    private func onErrorAction(_ error: Error) -> ___VARIABLE_moduleName:identifier___.Action { .alertAction(.errorResponse(error, 1)) }
    private func onErrorAction(_ error: Error, _ unsentActionsCount: Int) -> ___VARIABLE_moduleName:identifier___.Action { .alertAction(.errorResponse(error, unsentActionsCount)) }
}

// MARK: STATE
struct ___VARIABLE_moduleName:identifier___State {
    // MARK: Stored properties
    var activeRequests: Int = 0
    var destination: ___VARIABLE_moduleName:identifier___.Destination?
    var reduxAlert: ReduxAlert?
    
    var isLoading: Bool { activeRequests > 0 }
    
    // MARK: Computed properties
}
