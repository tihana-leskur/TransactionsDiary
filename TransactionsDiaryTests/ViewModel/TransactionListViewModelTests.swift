//
//  TransactionListViewModelTests.swift
//  TransactionsDiaryTests
//
//  Created by tihana leskur on 4/3/25.
//

import Combine
import SwiftUI
import XCTest
@testable import TransactionsDiary

final class TransactionListViewModelTests: XCTestCase {

    func testInitialBatchLoadedWhenScreenAppearsForFirstTime() {
        // Arrange
        let service = MockTransactionService(
            transactionRepository: MockTransactionRepository(
                databaseSource: MockDatabaseDataSource()
            ),
            remoteDataSource: MockTransactionRemoteDataSource(),
            authRepository: MockAuthRepository(
                secureDataSource: MockSecureDataSource(),
                remoteDataSource: MockAuthRemoteDataSource()
            ),
            networkReachabilityRepository: MockNetworkReachabilityRepository()
        )
        service.getTransactionsResult = .success([])
        let batchSize = 10
        let viewModel = TransactionsListViewModel(
            transactionsService: service,
            batchSize: batchSize
        )

        // Act and Assert
        do {
            let _ = try awaitPublisher(viewModel.$transactionsList.output(at: 1)) {
                viewModel.viewWillAppear()
            }
            XCTAssertEqual(service.getTransactionsPageCallsCount, 1)
            XCTAssertEqual(service.getPageIndexParameter, 0)
            XCTAssertEqual(service.getPageBatchSizeParameter, batchSize)
        } catch {
            XCTFail("TransactionListViewModelTests - initialBatchLoadedWhenScreenAppearsForFirstTime should have succeeded")
        }
    }

    func testScreenNotReloadedWhenAppearsForSecondTime() {
        // Arrange
        let service = MockTransactionService(
            transactionRepository: MockTransactionRepository(
                databaseSource: MockDatabaseDataSource()
            ),
            remoteDataSource: MockTransactionRemoteDataSource(),
            authRepository: MockAuthRepository(
                secureDataSource: MockSecureDataSource(),
                remoteDataSource: MockAuthRemoteDataSource()
            ),
            networkReachabilityRepository: MockNetworkReachabilityRepository()
        )
        let batchSize = 10
        service.getTransactionsResult = .success(createBatch(of: batchSize))
        let viewModel = TransactionsListViewModel(
            transactionsService: service,
            batchSize: batchSize
        )

        // Act and Assert
        do {
            let _ = try awaitPublisher(viewModel.$transactionsList.output(at: 1)) {
                viewModel.viewWillAppear()
            }
            let _ = try awaitForNoUpdates(viewModel.$transactionsList.output(at: 2)) {
                viewModel.viewWillAppear()
            }
            let _ = try awaitForNoUpdates(viewModel.$transactionsList.output(at: 3)) {
                viewModel.transactionAppearedAt(index: 0)
            }
            XCTAssertEqual(service.getTransactionsPageCallsCount, 1)
        } catch {
            XCTFail("TransactionListViewModelTests - initialBatchLoadedWhenScreenAppearsForFirstTime should have succeeded")
        }
    }

    func testNextBatchLoadedIfLoadingThresholdReached() {
        // Arrange
        let service = MockTransactionService(
            transactionRepository: MockTransactionRepository(
                databaseSource: MockDatabaseDataSource()
            ),
            remoteDataSource: MockTransactionRemoteDataSource(),
            authRepository: MockAuthRepository(
                secureDataSource: MockSecureDataSource(),
                remoteDataSource: MockAuthRemoteDataSource()
            ),
            networkReachabilityRepository: MockNetworkReachabilityRepository()
        )
        let batchSize = 10
        let loadingThreshold = 5
        service.getTransactionsResult = .success(createBatch(of: batchSize))
        let viewModel = TransactionsListViewModel(
            transactionsService: service,
            batchSize: batchSize,
            loadingThreshold: loadingThreshold
        )

        // Act and Assert
        do {
            let _ = try awaitPublisher(viewModel.$transactionsList.output(at: 1)) {
                viewModel.viewWillAppear()
            }
            let _ = try awaitPublisher(viewModel.$transactionsList.output(at: 1)) {
                viewModel.transactionAppearedAt(index: loadingThreshold)
            }
            XCTAssertEqual(service.getTransactionsPageCallsCount, 2)
            XCTAssertEqual(service.getPageIndexParameter, batchSize)
            XCTAssertEqual(service.getPageBatchSizeParameter, batchSize)
        } catch {
            XCTFail("TransactionListViewModelTests - initialBatchLoadedWhenScreenAppearsForFirstTime should have succeeded")
        }
    }

    func testBatchNotReloadedWhenUserScrollsUp() {
        // Arrange
        let service = MockTransactionService(
            transactionRepository: MockTransactionRepository(
                databaseSource: MockDatabaseDataSource()
            ),
            remoteDataSource: MockTransactionRemoteDataSource(),
            authRepository: MockAuthRepository(
                secureDataSource: MockSecureDataSource(),
                remoteDataSource: MockAuthRemoteDataSource()
            ),
            networkReachabilityRepository: MockNetworkReachabilityRepository()
        )
        let batchSize = 10
        let loadingThreshold = 5
        service.getTransactionsResult = .success(createBatch(of: batchSize))
        let viewModel = TransactionsListViewModel(
            transactionsService: service,
            batchSize: batchSize,
            loadingThreshold: loadingThreshold
        )

        // Act and Assert
        do {
            // load initial batch
            let _ = try awaitPublisher(viewModel.$transactionsList.output(at: 1)) {
                viewModel.viewWillAppear()
            }
            // loading threshold index appeared, load second batch
            let _ = try awaitPublisher(viewModel.$transactionsList.output(at: 1)) {
                viewModel.transactionAppearedAt(index: loadingThreshold)
            }
            // same loading threshold index appeared again / scrolling up
            let _ = try awaitForNoUpdates(viewModel.$transactionsList.output(at: 2)) {
                viewModel.transactionAppearedAt(index: loadingThreshold)
            }
            XCTAssertEqual(service.getTransactionsPageCallsCount, 2)
        } catch {
            XCTFail("TransactionListViewModelTests - initialBatchLoadedWhenScreenAppearsForFirstTime should have succeeded")
        }
    }
}


fileprivate func createBatch(of size: Int) -> [TransactionsDiary.Transaction] {
    var result: [TransactionsDiary.Transaction] = []
    for _ in 0..<size {
        result.append(TransactionsDiary.Transaction(
            id: UUID(),
            name: "test",
            timestamp: 0,
            amount: 0,
            currency: .eur,
            type: .invoice
        ))
    }
    return result
}
