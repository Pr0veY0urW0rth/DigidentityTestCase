//
//  AppDI.swift
//  DigidentityTestCase
//
//  Created by Daniil Bugaenko on 19.12.2025.
//

import FactoryKit

extension Container{
    var apiHelper: Factory<APIHelper> {
        self { APIHelperImpl(interceptors: [AuthorizationInterceptor()]) }.shared
    }
    
    var appConfigLoader: Factory<AppConfigLoader>{
        self {AppConfigLoader()}.shared
    }
}
