//
//  APIErrors.swift
//  DigidentityTestCase
//
//  Created by Daniil Bugaenko on 15.07.2025.
//

import Foundation

/// API error enum.
/// Contains possible errors for API responses.
enum APIError: LocalizedError {
    case unauthorized
    case validationError
    case serverError
    case invalidURL
    case failedToGetData
    case decodingFailed
    case noData
    case unknown
}

extension APIError {
    /// Error description.
    /// Gives a string description of error for UI.
    var localizedDescription: String {
        switch self {
        case .unauthorized:
            return "User is unauthorized!"
        case .validationError:
            return "Validation error!"
        case .serverError:
            return "Server error!"
        case .invalidURL:
            return "Provided URL is invalid!"
        case .failedToGetData:
            return "Failed to get data from the source!"
        case .decodingFailed:
            return "JSON decoding failed!"
        case .noData:
            return "No data is given!"
        case .unknown:
            return "Error is unknown!"
        }
    }
}

extension APIError: CaseIterable {
    static func random() -> APIError { APIError.allCases.randomElement()! }
}
