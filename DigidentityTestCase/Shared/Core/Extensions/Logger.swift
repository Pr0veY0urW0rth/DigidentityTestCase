//
//  Logger.swift
//  DigidentityTestCase
//
//  Created by Daniil Bugaenko on 15.07.2025.
//

import OSLog

/// Logger extensions for custom logs.
extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    /// Logger for network layer.
    static let network = Logger(subsystem: subsystem, category: "network")
    /// Logger for DI functionality
    static let cache = Logger(subsystem: subsystem, category: "cache")
    /// Logger for features layer.
    static let features = Logger(subsystem: subsystem, category: "features")
    /// Logger for user interface layer.
    static let userInterface = Logger(subsystem: subsystem, category: "userInterface")
}
