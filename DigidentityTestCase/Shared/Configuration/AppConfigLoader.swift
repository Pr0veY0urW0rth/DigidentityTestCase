//
//  AppConfigLoader.swift
//  DigidentityTestCase
//
//  Created by Daniil Bugaenko on 11.12.2025.
//

import Foundation

/// Loader for application configuration.
struct AppConfigLoader {
    private let config: [String: String]

    init() {
        if let url = Bundle.main.url(forResource: "Config", withExtension: "plist"),
           let dict = NSDictionary(contentsOf: url) as? [String: String] {
            config = dict
        } else {
            config = [:]
        }
    }

    func value<T: LosslessStringConvertible>(for key: String) -> T? {
        if let env = ProcessInfo.processInfo.environment[key],
           let value = T(env) { return value }

        if let val = config[key], let value = T(val) { return value }

        return nil
    }
}
