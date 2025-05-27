//
//  StoreViewHelpers.swift
//  TCA MVP
//
//  Created by Salvador on 3/25/25.
//

import SwiftUI

/// `StoreViewHelpers`: Anything `Syntactic sugar` that helps ease of use of `Redux` architecture.

/// Wrapper `Store` view to expose its `state` property  and `send` method without having to reference `store` all the time.
struct StoreView<State, Reducer: ReducerProtocol, Content: View>: View where Reducer.FeatureState == State {
    @StateObject var store: Store<State, Reducer>
    let content: (State, @escaping (Reducer.FeatureAction) -> Void) -> Content

    var body: some View {
        content(store.state) { action in store.send(action) }
    }
}

extension View {
    /// Custom `onChange` modifier named `onDestinationChange` for optional values.
    func onDestinationChange<V: Equatable>(of value: V?,
                                           perform action: @escaping (V) -> Void) -> some View {
        onChange(of: value) { if let value { action(value) } }
    }
}

struct OnDestinationCompletedModifier: ViewModifier {
    /// `hasAppeared` tracking to only apply when `View` re-appears.
    @State private var hasAppeared = false
    var action: () -> Void
    
    func body(content: Content) -> some View {
        content.onAppear { if hasAppeared { action() } else { hasAppeared = true } }
    }
}

extension View {
    /// Since navigation is finished whenever a user goes back to current `View`, we need to sync the `Store`.
    /// Upon navigation return, a `destinationCompleted` action must be sent to the `Store`, and the state driving the navigation should reset to `nil` to indicate there's no longer any view pushed/presented.
    func onDestinationCompleted(perform action: @escaping () -> Void) -> some View { modifier(OnDestinationCompletedModifier(action: action)) }
}

extension View {
    /// A reusable modifier that listens for changes in an optional `ReduxAlert` value, updates `@State`, and automatically presents an alert.
    func onReduxAlertChange(of alert: ReduxAlert?,
                            update isAlertPresented: Binding<Bool>) -> some View {
        onChange(of: alert) { isAlertPresented.wrappedValue = alert != nil }
            /// Will not present a new `alert` if one is already displayed, since `isPresented` remains `true` (`true == true`), indicating no state change.
            .alert(isPresented: isAlertPresented) { reduxAlertConfigAdapter(alert!).alert } /// `isAlertPresented` <-> `alert != nil`
    }
    
    private func reduxAlertConfigAdapter(_ swiftUIAlert: ReduxAlert) -> ReduxAlertConfig {
        switch swiftUIAlert {
        case .error: ReduxAlertConfig(title: "Network Error", message: "Something went wrong. Please try again later.")
        case .custom(let swiftUIAlertConfig): swiftUIAlertConfig
        }
    }
}

struct OnReduxAlertDismissModifier: ViewModifier {
    @Binding var isAlertPresented: Bool
    let onDismiss: () -> Void
    @State private var wasPresented = false

    func body(content: Content) -> some View {
        content
            .onChange(of: isAlertPresented) {
                if wasPresented, !isAlertPresented { onDismiss() }
                wasPresented = isAlertPresented
            }
    }
}

extension View {
    /// Since `.alert` sets `isPresented` to `false` whenever an alert button is interacted with, we need to sync the `Store`.
    /// Upon alert dismissal, `alertCompleted` action must be sent to the `Store`, and the state driving the alert should reset to `nil` to indicate it's no longer presented.
    func onReduxAlertDismiss(isAlertPresented: Binding<Bool>, perform action: @escaping () -> Void) -> some View {
        modifier(OnReduxAlertDismissModifier(isAlertPresented: isAlertPresented, onDismiss: action))
    }
}
