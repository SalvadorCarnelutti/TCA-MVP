//
//  Dependency.swift
//  TCA MVP
//
//  Created by Salvador on 3/25/25.
//

import Foundation

/** Implementation inspired from `SwiftLee`'s: **https://www.avanderlee.com/swift/dependency-injection** */

/**
 This is a way to create our own customs domains of dependencies similar to that of  `SwiftUI`'s `EnvironmentValues`.
 Instead of adding to `@Environment`'s domain, we just create our own `Feature` domains that are better localized (Local to a single feature).
 */
public protocol DependencyKey {
    /// The associated type representing the type of the dependency injection key's value.
    associatedtype Value

    /// The default value for the dependency injection key.
    static var currentValue: Self.Value { get set } /** Can be overridden at runtime for unit testing.
                                                     It’s important to point out that adjusting the dependency using the `DependencyValues` static subscript also affects already injected properties.
                                                     This can be done as follows: `DependencyValues[\.<YourDependencyName>] = <YourDependencyNameInstance>` */
}

/// Provides access to injected dependencies.
struct DependencyValues {
    /// This is only used as an accessor to the computed properties within extensions of `DependencyValues`.
    private static var current = DependencyValues()
    
    /// A static subscript for updating the `currentValue` of `DependencyKey` instances.
    static subscript<K>(key: K.Type) -> K.Value where K : DependencyKey {
        get { key.currentValue }
        set { key.currentValue = newValue }
    }
    
    /// A static subscript accessor for updating and references dependencies directly.
    static subscript<T>(_ keyPath: WritableKeyPath<DependencyValues, T>) -> T {
        get { current[keyPath: keyPath] }
        set { current[keyPath: keyPath] = newValue }
    }
}

@propertyWrapper
struct Dependency<T> {
    private let keyPath: WritableKeyPath<DependencyValues, T>
    var wrappedValue: T {
        get { DependencyValues[keyPath] }
        set { DependencyValues[keyPath] = newValue }
    }
    
    init(_ keyPath: WritableKeyPath<DependencyValues, T>) { self.keyPath = keyPath }
}
