//
//  ___FILEHEADER___
//

import SwiftUI

final class ___VARIABLE_moduleName:identifier___ViewController: UIViewController {
    private let content: ___VARIABLE_moduleName:identifier___View
    
    init(content: ___VARIABLE_moduleName:identifier___View) {
        self.content = content
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSwiftUIView(content)
    }
}

struct ___VARIABLE_moduleName:identifier___View: View {
    let store: Store<___VARIABLE_moduleName:identifier___State, ___VARIABLE_moduleName:identifier___Reducer>
    @State private var isAlertPresented = false
    let router: ___VARIABLE_moduleName:identifier___ViewRouter
        
    var body: some View {
        StoreView(store: store) { state, send in
            EmptyView() // YOUR IMPLEMENTATION
                .spinnerOverlay(isLoading: state.isLoading)
            /// Destination
            .onDestinationChange(of: state.destination, perform: router.goTo(_:))
            .onDestinationCompleted(perform: { send(.destinationAction(.destinationCompleted)) })
            /// ReduxAlert
            .onReduxAlertChange(of: state.reduxAlert, update: $isAlertPresented)
            .onReduxAlertDismiss(isAlertPresented: $isAlertPresented, perform: { send(.alertAction(.alertCompleted)) })
        }
    }
}
