//
//  RequestInterceptor.swift
//  DigidentityTestCase
//
//  Created by Daniil Bugaenko on 05.12.2025.
//
import Foundation

protocol RequestInterceptor {
    func intercept(_ request: URLRequest) throws -> URLRequest
}
