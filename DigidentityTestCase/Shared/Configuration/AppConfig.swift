//
//  AppConfig.swift
//  DigidentityTestCase
//
//  Created by Daniil Bugaenko on 15.07.2025.
//

import Foundation

/// Configuration of aapplication.
enum AppConfig {
    /// Base of API URL.
    /// Needed for creating what URL will be used in corresponding configuration.
    @EnvironmentKey("API_URL")
    static var apiURL: String
    /// Authorization Key.
    /// Needed for authentication within the server.
    @EnvironmentKey("AUTH_KEY")
    static var authorizationKey: String
}
