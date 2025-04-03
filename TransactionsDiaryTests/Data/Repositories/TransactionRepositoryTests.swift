//
//  TransactionRepositoryTests.swift
//  TransactionsDiaryTests
//
//  Created by tihana leskur on 4/3/25.
//

import Combine
import XCTest
@testable import TransactionsDiary

final class TransactionRepositoryTests: XCTestCase {

    func testUserIdAddedToQueryParameters() {
        // Arrange
        let userId = UUID()
        let dataSource = MockDatabaseDataSource()
        dataSource.getResult = .success([])
        let repository = DefaultTransactionRepository(
            databaseSource: dataSource
        )
        let fetchPublisher: Future<[Transaction], Error> = repository.getTransactions(
            userId: userId,
            parameters: nil
        )
        let expectedQueryPredicate = NSPredicate(format: "userId = %@", userId.uuidString)

        // Act and Assert
        do {
            let _ = try awaitPublisher(fetchPublisher.eraseToAnyPublisher())
            let usedQuery = dataSource.usedFetchQuery
            XCTAssertEqual(usedQuery?.predicate, expectedQueryPredicate)
        } catch {
            XCTFail("TransactionRepositoryTests - testFetchIfNoSortParametersUsesDefault should have succeeded")
        }
    }

    func testFetchIfNoSortParametersUsesDefault() {
        // Arrange
        let dataSource = MockDatabaseDataSource()
        dataSource.getResult = .success([])
        let repository = DefaultTransactionRepository(
            databaseSource: dataSource
        )
        let fetchPublisher: Future<[Transaction], Error> = repository.getTransactions(
            userId: UUID(),
            parameters: nil
        )
        let expectedSortParameters = repository.defaultSortDescriptors
        
        // Act and Assert
        do {
            let _ = try awaitPublisher(fetchPublisher.eraseToAnyPublisher())
            let usedQuery = dataSource.usedFetchQuery
            XCTAssertEqual(usedQuery?.sortDescriptors, expectedSortParameters)
        } catch {
            XCTFail("TransactionRepositoryTests - testFetchIfNoSortParametersUsesDefault should have succeeded")
        }
    }

    func testFetchOffsetSetToBegginingIfFetchLimitExistsButNoDesiredFetchOffsetProvided() {
        // Arrange
        let dataSource = MockDatabaseDataSource()
        dataSource.getResult = .success([])
        let repository = DefaultTransactionRepository(
            databaseSource: dataSource
        )
        let fetchPublisher: Future<[Transaction], Error> = repository.getTransactions(
            userId: UUID(),
            parameters: RepositoryQueryParameters(fetchLimit: 3)
        )
        let expectedFetchOffset = 0
        
        // Act and Assert
        do {
            let _ = try awaitPublisher(fetchPublisher.eraseToAnyPublisher())
            let usedQuery = dataSource.usedFetchQuery
            XCTAssertEqual(usedQuery?.fetchOffset, expectedFetchOffset)
        } catch {
            XCTFail("TransactionRepositoryTests - testFetchIfNoSortParametersUsesDefault should have succeeded")
        }
    }
}
