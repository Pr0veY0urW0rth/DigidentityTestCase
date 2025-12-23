//
//  DigidentityTestCaseApp.swift
//  DigidentityTestCase
//
//  Created by Daniil Bugaenko on 19.12.2025.
//

import SwiftUI

@main
struct DigidentityTestCaseApp: App {
    init() {
        NukePipelines.registerSVGDecoder()
        }
    
    var body: some Scene {
        WindowGroup {
            CatalogRootView()
        }
    }
}
