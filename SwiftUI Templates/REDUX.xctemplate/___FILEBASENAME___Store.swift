//
//  ___FILEHEADER___
//

import SwiftUI

// MARK: ACTION
struct ___VARIABLE_moduleName:identifier___ {
    enum Action {
        // case yourAction
    }
}

// MARK: REDUCER
struct ___VARIABLE_moduleName:identifier___Reducer: ReducerProtocol {
    func reduce(state: ___VARIABLE_moduleName:identifier___State, action: ___VARIABLE_moduleName:identifier___.Action) -> ReducerResult<___VARIABLE_moduleName:identifier___State, ___VARIABLE_moduleName:identifier___.Action> {
        var newState = state
        
        switch action {
        // case .yourAction...
        }

        return ReducerResult(newState: newState, effectGroup: nil)
    }
}

// MARK: STATE
struct ___VARIABLE_moduleName:identifier___State {
    // MARK: Stored properties
    
    // MARK: Computed properties
}
