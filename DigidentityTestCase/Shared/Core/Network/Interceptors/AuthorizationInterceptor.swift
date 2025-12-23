//
//  AuthorizationInterceptor.swift
//  DigidentityTestCase
//
//  Created by Daniil Bugaenko on 19.12.2025.
//

import Foundation
import OSLog

final class AuthorizationInterceptor: RequestInterceptor{
    func intercept(_ request: URLRequest) throws -> URLRequest {
        Logger.network.info("Started organization interception.")
        var modified = request
        modified.setValue(
            AppConfig.authorizationKey,
            forHTTPHeaderField: "Authorization"
        )
        defer{
            Logger.network.info("Exited interception with modified request.")
        }
        return modified
    }
    
    
}
