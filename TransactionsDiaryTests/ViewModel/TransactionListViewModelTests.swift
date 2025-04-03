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
        service.getTransactionsResult = .success([])
        let batchSize = 10
        let viewModel = TransactionsListViewModel(
            transactionsService: service,
            batchSize: batchSize
        )

        // Act and Assert
        do {
            let _ = try awaitForNoUpdates(viewModel.$transactionsList.output(at: 2)) {
                viewModel.viewWillAppear()
                viewModel.viewWillAppear()
            }
            XCTAssertEqual(service.getTransactionsPageCallsCount, 1)
            XCTAssertEqual(service.getPageIndexParameter, 0)
            XCTAssertEqual(service.getPageBatchSizeParameter, batchSize)
        } catch {
            XCTFail("TransactionListViewModelTests - initialBatchLoadedWhenScreenAppearsForFirstTime should have succeeded")
        }
    }
}
