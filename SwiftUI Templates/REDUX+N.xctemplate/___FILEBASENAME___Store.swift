//
//  ___FILEHEADER___
//

import SwiftUI

// MARK: ACTION
struct ___VARIABLE_moduleName:identifier___ {
    enum Action {
        // case yourAction
        case destinationAction(DestinationAction)
        
        enum DestinationAction {
            // case yourDestinationAction
            case destinationCompleted
        }
    }

    enum Destination: Equatable {
        // case yourDestination
    }
}

// MARK: REDUCER
struct ___VARIABLE_moduleName:identifier___Reducer: ReducerProtocol {
    func reduce(state: ___VARIABLE_moduleName:identifier___State, action: ___VARIABLE_moduleName:identifier___.Action) -> ReducerResult<___VARIABLE_moduleName:identifier___State, ___VARIABLE_moduleName:identifier___.Action> {
        var newState = state
        
        switch action {
        // case .yourAction...
        case .destinationAction(let destinationAction):
            switch destinationAction {
            case .destinationCompleted:
                newState.destination = nil
            }
        }

        return ReducerResult(newState: newState, effectGroup: nil)
    }
}

// MARK: STATE
struct ___VARIABLE_moduleName:identifier___State {
    // MARK: Stored properties
    var destination: ___VARIABLE_moduleName:identifier___.Destination?
    
    // MARK: Computed properties
}
