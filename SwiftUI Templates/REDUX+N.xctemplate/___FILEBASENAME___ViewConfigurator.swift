//
//  ___FILEHEADER___
//

import SwiftUI

final class ___VARIABLE_moduleName:identifier___ViewConfigurator {
    func build(state: ___VARIABLE_moduleName:identifier___State = ___VARIABLE_moduleName:identifier___State(), reducer: ___VARIABLE_moduleName:identifier___Reducer = ___VARIABLE_moduleName:identifier___Reducer()) -> ___VARIABLE_moduleName:identifier___ViewController {
        let store = Store(state: state, reducer: reducer)
        let router = ___VARIABLE_moduleName:identifier___ViewRouterImplementation()
        let contentView = ___VARIABLE_moduleName:identifier___View(store: store, router: router)
        let viewController = ___VARIABLE_moduleName:identifier___ViewController(content: contentView)
        router.set(withCurrentViewController: viewController)
        
        return viewController
    }
}
