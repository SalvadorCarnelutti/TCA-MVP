//
//  WrapperModifiers.swift
//  TCA MVP
//
//  Created by Salvador on 3/25/25.
//

import SwiftUI

/// `WrapperModifiers`: Intended for `modifier`s that wrap `Content` around a new `View`.

struct SpinnerOverlayModifier: ViewModifier {
    let isLoading: Bool

    func body(content: Content) -> some View {
        ZStack {
            content
            if isLoading {
                if #available(iOS 15.0, *) {
                    ProgressView().controlSize(.large)
                } else {
                    ProgressView().scaleEffect(1.74)
                }
            }
        }
    }
}

extension View {
    func spinnerOverlay(isLoading: Bool) -> some View { modifier(SpinnerOverlayModifier(isLoading: isLoading)) }
}
