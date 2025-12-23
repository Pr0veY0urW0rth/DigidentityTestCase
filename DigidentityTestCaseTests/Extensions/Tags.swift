//
//  Tags.swift
//  DigidentityTestCaseTests
//
//  Created by Daniil Bugaenko on 23.12.2025.
//

import Testing

extension Tag {
    // MARK: test feauture

    @Tag static var catalog: Self

    // MARK: test type

    @Tag static var unitTest: Self
    @Tag static var integrationTest: Self
    @Tag static var systemTest: Self
}
