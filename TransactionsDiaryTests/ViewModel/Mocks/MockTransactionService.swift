//
//  MockTransactionService.swift
//  TransactionsDiaryTests
//
//  Created by tihana leskur on 4/3/25.
//

import Combine
import Foundation
@testable import TransactionsDiary

final class MockTransactionService: TransactionService {
    var createTransactionResult: Result<Void, Error> = .success(())
    var getTransactionsResult: Result<[Transaction], Error> = .success([])
    var getTransactionDetailsResult: Result<TransactionDetails, Error> = .success(.empty)

    var getTransactionsPageCallsCount: Int = 0
    var getPageIndexParameter: Int?
    var getPageBatchSizeParameter: Int?
    
    init(
        transactionRepository: TransactionRepository,
        remoteDataSource: TransactionRemoteDataSource,
        authRepository: AuthRepository,
        networkReachabilityRepository: NetworkReachabilityRepository) {}
    
    func addTransaction(_ transaction: TransactionDetails) -> AnyPublisher<Void, Error> {
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
        .eraseToAnyPublisher()
    }

    func getAllTransactions() -> Future<[Transaction], Error> {
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

    func getLastTransactions(count: Int) -> Future<[Transaction], Error> {
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

    func getTransactions(from index: Int, batchSize: Int) -> Future<[Transaction], Error> {
        getTransactionsPageCallsCount += 1
        getPageIndexParameter = index
        getPageBatchSizeParameter = batchSize
        return Future<[Transaction], Error> { [weak self] promise in
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
}
