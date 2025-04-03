//
//  DatabaseRepositoryFactory.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 4/1/25.
//

import Foundation

enum DatabaseType {
    case coreData
}

protocol DatabaseRepositoryFactory {
    init() async throws
    func createTransactionRepository() -> TransactionRepository
}
