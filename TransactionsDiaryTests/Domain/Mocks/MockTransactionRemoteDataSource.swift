//
//  MockTransactionRemoteDataSource.swift
//  TransactionsDiaryTests
//
//  Created by tihana leskur on 4/3/25.
//

import Combine
import Foundation
@testable import TransactionsDiary

final class MockTransactionRemoteDataSource: TransactionRemoteDataSource {
    var createTransactionsResult: Result<Void, Error> = .success(())
    var createTransactionResult: Result<Void, Error> = .success(())
    var didCallCreate = false

    func addTransaction(_ transaction: TransactionDetails) -> Future<Void, Error> {
        didCallCreate = true
        return Future<Void, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(DatabaseError.deallocated))
                return
            }
            switch self.createTransactionResult {
            case .success:
                promise(.success(()))
            case .failure(let error):
                promise(.failure(error))
            }
        }
    }
    
    func addTransactions(_ transactions: [TransactionDetails]) -> Future<Void, Error> {
        Future<Void, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(DatabaseError.deallocated))
                return
            }
            switch self.createTransactionsResult {
            case .success:
                promise(.success(()))
            case .failure(let error):
                promise(.failure(error))
            }
        }
    }
}
