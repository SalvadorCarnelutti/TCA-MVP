//
//  ReduxAlertEnums.swift
//  TCA MVP
//
//  Created by Salvador on 4/29/25.
//

import Foundation

/// General `redux` involved alert actions.
enum AlertAction {
    case errorResponse(Error, Int) /// `Int` represents the count of unsent actions to the `Store` because an error was thrown. `State`'s `activeRequests` must be decremented accordingly.
    case alertCompleted /// Resets `State`'s `destination`.
}

/**
 Represents underlying information to display an `Alert`:
 - `error` for standardized error handling.
 - `custom` for any other `Alert` setup requirement.
 */
enum ReduxAlert: Equatable {
    case error
    case custom(ReduxAlertConfig)
}
