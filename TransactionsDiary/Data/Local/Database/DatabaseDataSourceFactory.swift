//
//  DatabaseDataSourceFactory.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 4/6/25.
//

import Foundation

enum DatabaseType {
    case coreData
}

protocol DatabaseDataSourceFactory {
    init(inMemory: Bool) async throws
    func userInteractiveDataSource() -> DatabaseDataSource
    func backgroundDataSource() -> DatabaseDataSource
}

// TODO: tihana move to Concurrency+Extensions
extension AsyncThrowingStream {
    func result() async throws -> Element? {
        var result: Element?
        for try await element in self {
            result = element
            break
        }
        return result
    }
}
