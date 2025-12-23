//
//  EnvironmentKey.swift
//  DigidentityTestCase
//
//  Created by Daniil Bugaenko on 15.07.2025.
//

import Foundation
import FactoryKit

/// Property wrapper for custom environment keys in the application scheme and configuration.
@propertyWrapper
struct EnvironmentKey<T: LosslessStringConvertible> {
    let key: String
    var wrappedValue: T

    init(_ key: String) {
        self.key = key

        if let value: T = Container.shared.appConfigLoader.resolve().value(for: key) {
            wrappedValue = value
        } else {
            fatalError(
                "Environment variable or config for \(key) not found or cannot convert to \(T.self)"
            )
        }
    }
}
