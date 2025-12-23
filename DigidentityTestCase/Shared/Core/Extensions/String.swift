//
//  String.swift
//  DigidentityTestCase
//
//  Created by Daniil Bugaenko on 15.09.2025.
//

import Foundation

extension String {
    /// Conversion string elements for creating API path.
    static func path(_ components: String...) -> String {
        components.joined(separator: "/")
    }
}
