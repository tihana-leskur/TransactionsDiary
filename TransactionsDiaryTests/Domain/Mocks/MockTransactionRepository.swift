//
//  MockTransactionRepository.swift
//  TransactionsDiaryTests
//
//  Created by tihana leskur on 4/3/25.
//

import Combine
import Foundation
@testable import TransactionsDiary

final class MockTransactionRepository: TransactionRepository {
    var createTransactionsResult: Result<Void, Error> = .success(())
    var createTransactionResult: Result<Void, Error> = .success(())
    var getTransactionsResult: Result<[Transaction], Error> = .success([])
    var getTransactionDetailsResult: Result<TransactionDetails, Error> = .success(.empty)

    init(databaseSource: DatabaseDataSource) {}
    
    func createTransaction(_ transaction: TransactionDetails, for userId: UUID) -> Future<Void, Error> {
        Future<Void, Error> { [weak self] promise in
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
    
    func createTransactions(_ transaction: [TransactionDetails], for userId: UUID) -> Future<Void, Error> {
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
    
    func getTransactions(
        userId: UUID,
        parameters: RepositoryQueryParameters?
    ) -> Future<[Transaction], Error> {
        Future<[Transaction], Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(DatabaseError.deallocated))
                return
            }
            switch self.getTransactionsResult {
            case .success(let models):
                promise(.success(models))
            case .failure(let error):
                promise(.failure(error))
            }
        }
    }
    
    func getTransactionDetails(id: UUID) -> Future<TransactionDetails, Error> {
        Future<TransactionDetails, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(DatabaseError.deallocated))
                return
            }
            switch self.getTransactionDetailsResult {
            case .success(let model):
                promise(.success(model))
            case .failure(let error):
                promise(.failure(error))
            }
        }
    }
}

extension TransactionDetails {
    static let empty = TransactionDetails(
        id: UUID(),
        name: "",
        timestamp: 0,
        amount: 0,
        currency: .eur,
        type: .invoice,
        imageId: UUID(),
        imageData: Data()
    )
}
