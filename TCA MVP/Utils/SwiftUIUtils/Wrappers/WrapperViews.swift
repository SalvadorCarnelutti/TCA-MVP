//
//  WrapperViews.swift
//  TCA MVP
//
//  Created by Salvador on 3/25/25.
//

import SwiftUI

/// `WrapperViews`: Intended for `View`s that wrap `Content` around a new `View`.

/// Wrapper view to display `Content` only when condition is `true`
struct ConditionalView<Content: View>: View {
    let condition: Bool
    let content: () -> Content
    
    init(_ condition: Bool, content: @escaping () -> Content) {
        self.condition = condition
        self.content = content
    }
    
    var body: some View {
        if condition { content() } else { EmptyView() }
    }
}

/// Wrapper view to display `Content` only when `Value` is non `nil`
struct ConditionalValueView<Value: Any, Content: View>: View {
    var value: Value?
    var content: (Value) -> Content

    init(value: Value?, @ViewBuilder content: @escaping (Value) -> Content) {
        self.value = value
        self.content = content
    }

    var body: some View {
        if let value { content(value) } else { EmptyView() }
    }
}
