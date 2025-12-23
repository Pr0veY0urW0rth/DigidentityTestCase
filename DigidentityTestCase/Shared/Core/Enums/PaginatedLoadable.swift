//
//  PaginatedLoadable.swift
//  DigidentityTestCase
//
//  Created by Daniil Bugaenko on 22.12.2025.
//

import Foundation

struct PaginatedData<T> {
    var items: [T] = []
    var lastID: String?
    var isCompleted: Bool = false
}

enum PaginatedLoadable<T> {
    case idle(data: PaginatedData<T> = PaginatedData())
    case loading(data: PaginatedData<T>)
    case loaded(PaginatedData<T>)
    case failed(Error, data: PaginatedData<T>)

    var data: PaginatedData<T> {
        switch self {
                case .idle(let data), .loading(let data), .failed(_, let data), .loaded(let data):
                    return data
                }
    }

    var error: Error? {
        if case .failed(let err, _) = self { return err }
                return nil
    }
    
    var isLoading: Bool {
            if case .loading = self { return true }
            return false
        }
    
    var isSuccess: Bool{
        if case .loaded = self {
            return true
        }
        return false
    }
    
    var isFailed: Bool{
        if case .failed = self {
            return true
        }
        return false
    }
}
