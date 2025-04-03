//
//  TransactionServiceTests.swift
//  TransactionsDiaryTests
//
//  Created by tihana leskur on 4/3/25.
//

import Combine
import XCTest
@testable import TransactionsDiary

final class TransactionServiceTests: XCTestCase {

    func testRequestNotExecutedIfCurrentUserDoesNotExist() {
        // Arrange
        let transactionRepository = MockTransactionRepository(
            databaseSource: MockDatabaseDataSource()
        )
        let remoteDataSource = MockTransactionRemoteDataSource()
        let authRepository = MockAuthRepository(
            secureDataSource: MockSecureDataSource(),
            remoteDataSource: MockAuthRemoteDataSource()
        )
        let networkReachabilityRepository = MockNetworkReachabilityRepository()
        
        let service = DefaultTransactionService(
            transactionRepository: transactionRepository,
            remoteDataSource: remoteDataSource,
            authRepository: authRepository,
            networkReachabilityRepository: networkReachabilityRepository
        )

        // Act and Assert
        do {
            let _ = try awaitForFailure(service.addTransaction(.empty))
            XCTFail("TransactionServiceTests - testRequestNotExecutedIfCurrentUserDoesNotExist should have failed")
        } catch {
            print("TransactionServiceTests - testRequestNotExecutedIfCurrentUserDoesNotExist SUCCESS")
        }
    }

    func testDataNotSyncedWithRemoteIfNetworkNotAvailable() {
        // Arrange
        let transactionRepository = MockTransactionRepository(
            databaseSource: MockDatabaseDataSource()
        )
        let remoteDataSource = MockTransactionRemoteDataSource()
        let authRepository = MockAuthRepository(
            secureDataSource: MockSecureDataSource(),
            remoteDataSource: MockAuthRemoteDataSource()
        )
        authRepository.currentUser = User(id: UUID(), password: "")
        let networkReachabilityRepository = MockNetworkReachabilityRepository()
        networkReachabilityRepository.currentNetworkStatus = .none
        
        let service = DefaultTransactionService(
            transactionRepository: transactionRepository,
            remoteDataSource: remoteDataSource,
            authRepository: authRepository,
            networkReachabilityRepository: networkReachabilityRepository
        )

        // Act and Assert
        do {
            let _ = try awaitPublisher(service.addTransaction(.empty))
            XCTAssertFalse(remoteDataSource.didCallCreate)
        } catch {
            XCTFail("TransactionServiceTests - dataNotSyncedWithRemoteIfNetworkNotAvailable should have succeeded")
        }
    }
}
