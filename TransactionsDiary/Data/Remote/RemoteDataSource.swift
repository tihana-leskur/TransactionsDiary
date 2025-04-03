//
//  RemoteDataSource.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 3/30/25.
//

import Combine
import Foundation

protocol TransactionRemoteDataSource {
    func addTransaction(_ transaction: TransactionDetails) -> Future<Void, Error>
    func addTransactions(_ transactions: [TransactionDetails]) -> Future<Void, Error>
}

protocol AuthRemoteDataSource {}

protocol RemoteDataSource: TransactionRemoteDataSource, AuthRemoteDataSource {
    init(httpClient: HttpClient)
}

final class DefaultRemoteDataSource: RemoteDataSource {
    private let httpClient: HttpClient
    
    init(httpClient: HttpClient) {
        self.httpClient = httpClient
    }
    
    func addTransaction(_ transaction: TransactionDetails) -> Future<Void, Error> {
        Future<Void, Error> { promise in
            promise(.success(()))
        }
    }

    func addTransactions(_ transactions: [TransactionDetails]) -> Future<Void, Error> {
        Future<Void, Error> { promise in
            promise(.success(()))
        }
    }
}
