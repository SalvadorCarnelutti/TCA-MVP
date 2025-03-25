//
//  ___FILEHEADER___
//

import UIKit

protocol ___VARIABLE_moduleName:identifier___ViewRouter {
    func goTo(_ destination: ___VARIABLE_moduleName:identifier___.Destination)
}

final class ___VARIABLE_moduleName:identifier___ViewRouterImplementation: ___VARIABLE_moduleName:identifier___ViewRouter {
    private weak var viewController: UIViewController?
    
    func set(withCurrentViewController viewController: UIViewController) { self.viewController = viewController }

    func goTo(_ destination: ___VARIABLE_moduleName:identifier___.Destination) {
        switch destination {
        // case .yourDestination...
        }
    }
}
