//
//  ReduxAlert.swift
//  TCA MVP
//
//  Created by Salvador on 3/25/25.
//

import SwiftUI

/**
 Represents underlying information to display an `Alert`:
 - `error` for standardized error handling.
 - `custom` for any other `Alert` setup requirement.
 */
enum ReduxAlert: Equatable {
    case error
    case custom(ReduxAlertConfig)
}

/**
 Either or both `primaryAction` and `secondaryAction` are optionals since `SwiftUI` automatically dismisses alerts when any alert button is tapped.
 When configured, in addition to dismissing the alert, they can perform additional operations. However, since we are using a `Redux` architecture, those operations must be encapsulated within `Action`s.
 Conforms to `Equatable` since `onReduxAlertChange` implementation depends on it.
 **/
struct ReduxAlertConfig: Equatable {
    let title: String
    let message: String?
    var primaryActionButton: AlertButton? = nil
    var secondaryActionButton: AlertButton? = nil
    
    var alert: Alert {
        let defaultPrimaryAction = primaryActionButton?.alertButton ?? .default(Text("OK"))
        
        return switch (message, secondaryActionButton) {
        case (.some(let message), .some(let secondaryAction)):
            Alert(title: Text(title),
                  message: Text(message),
                  primaryButton: defaultPrimaryAction,
                  secondaryButton: secondaryAction.alertButton)
        case (.none, .some(let secondaryAction)):
            Alert(title: Text(title),
                  primaryButton: defaultPrimaryAction,
                  secondaryButton: secondaryAction.alertButton)
        case (.some(let message), .none):
            Alert(title: Text(title),
                  message: Text(message),
                  dismissButton: defaultPrimaryAction)
        case (.none, .none):
            Alert(title: Text(title),
                  dismissButton: defaultPrimaryAction)
        }
    }
}

/// An abstraction of `Alert.Button`.
struct AlertButton {
    var title: String?
    var action: (() -> ())?
    
    var alertButton: Alert.Button {
        Alert.Button.default(Text(title ?? "OK"), action: { action?() })
    }
}

extension AlertButton: Equatable {
    static func == (lhs: AlertButton, rhs: AlertButton) -> Bool { lhs.title == rhs.title }
}
