//
//  CoreDataDataSourceFactoryTests.swift
//  TransactionsDiaryTests
//
//  Created by tihana leskur on 4/6/25.
//

import Combine
import CoreData
import XCTest
@testable import TransactionsDiary


final class CoreDataDataSourceFactoryTests: CoreDataTest {

    func testFactoryDataSourceType() async throws {
        // Arrange
        var factory: CoreDataDataSourceFactory?
        do {
            factory = try await CoreDataDataSourceFactory(inMemory: true)
        } catch {
            XCTFail("CoreDataDataSourceFactoryTests - Store failed to load \(error)")
            return
        }

        // Act
        let mainDataSource = factory?.userInteractiveDataSource()
        let backgroundDataSource = factory?.backgroundDataSource()

        // Assert
        XCTAssertTrue(mainDataSource is CoreDataSource)
        XCTAssertTrue(backgroundDataSource is CoreDataSource)
    }

    func testBackgroundDataSourceUsesBackgroundContext() async throws {
        // Arrange
        var factory: CoreDataDataSourceFactory?
        do {
            factory = try await CoreDataDataSourceFactory(inMemory: true)
        } catch {
            XCTFail("CoreDataDataSourceFactoryTests - Store failed to load \(error)")
            return
        }

        // Act
        let dataSource = factory?.backgroundDataSource()

        // Assert
        guard let dataSourceContext = dataSource?.context as? NSManagedObjectContext else {
            XCTFail("CoreDataDataSourceFactoryTests - Invalid data source type")
            return
        }
        XCTAssertTrue(dataSourceContext != factory?.container.viewContext)
    }

    func testUserInteractiveDataSourceUsesMainContext() async throws {
        // Arrange
        var factory: CoreDataDataSourceFactory?
        do {
            factory = try await CoreDataDataSourceFactory(inMemory: true)
        } catch {
            XCTFail("CoreDataDataSourceFactoryTests - Store failed to load \(error)")
            return
        }

        // Act
        let dataSource = factory?.userInteractiveDataSource()

        // Assert
        guard let dataSourceContext = dataSource?.context as? NSManagedObjectContext else {
            XCTFail("CoreDataDataSourceFactoryTests - Invalid data source type")
            return
        }
        XCTAssertTrue(dataSourceContext == factory?.container.viewContext)
    }

    func testMainContextSetToAutomaticallyUpdateFromParent() async throws {
        // Arrange
        var factory: CoreDataDataSourceFactory?
        do {
            factory = try await CoreDataDataSourceFactory(inMemory: true)
        } catch {
            XCTFail("CoreDataDataSourceFactoryTests - Store failed to load \(error)")
            return
        }
        let mainDataSourceContext = factory?.userInteractiveDataSource().context as? NSManagedObjectContext
        let backgroundDataSourceContext = factory?.backgroundDataSource().context as? NSManagedObjectContext
        guard let mainDataSourceContext = mainDataSourceContext,
              let backgroundDataSourceContext = backgroundDataSourceContext else {
            XCTFail("CoreDataDataSourceFactoryTests - Invalid data source type")
            return
        }

        // Act
        try backgroundDataSourceContext.performAndWait {
            let transactionEntity = TransactionEntity(context: backgroundDataSourceContext)
            transactionEntity.fromDomainModel(createTransaction())
            backgroundDataSourceContext.insert(transactionEntity)
            let imageEntity = ImageEntity(context: backgroundDataSourceContext)
            imageEntity.fromDomainModel(createImage())
            backgroundDataSourceContext.insert(imageEntity)
            transactionEntity.setValue(imageEntity, forKey: RelationName.image.rawValue)
            try backgroundDataSourceContext.save()
        }

        // Assert
        try mainDataSourceContext.performAndWait {
            let results = try mainDataSourceContext.fetch(TransactionEntity.fetchRequest())
            XCTAssertTrue(results.count == 1)
        }
    }
}
