//
//  CoreDataSourceTests.swift
//  TransactionsDiaryTests
//
//  Created by tihana leskur on 4/3/25.
//

import Combine
import CoreData
import XCTest
@testable import TransactionsDiary

final class CoreDataSourceTests: XCTestCase {
    var persistentContainer: NSPersistentContainer?

    private func loadStore() -> Future<Void, Error> {
        Future<Void, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(DatabaseError.deallocated))
                return
            }
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            let container = NSPersistentContainer(name: "TransactionDiary")
            container.persistentStoreDescriptions = [description]
            container.loadPersistentStores { [weak self] _, error in
                if let error = error as NSError? {
                    promise(.failure(error))
                } else {
                    self?.persistentContainer = container
                    promise(.success(()))
                }
            }
        }
    }

    func testCreate() throws {
        // Arrange
        let transactionId1 = UUID()
        let userId1 = UUID()
        let imageId1 = UUID()
        let transaction1: TransactionModel = TransactionModel(
            id: transactionId1,
            userId: userId1,
            name: "test1",
            timestamp: 10,
            amount: 555,
            currency: Currency.eur.rawValue,
            type: TransactionType.invoice.rawValue
        )
        let image1: ImageModel = ImageModel(
            id: imageId1,
            data: Data()
        )
        var dataSource: CoreDataSource?
        do {
            let _ = try awaitPublisher(loadStore().eraseToAnyPublisher())
            let context = persistentContainer!.newBackgroundContext()
            dataSource = CoreDataSource(managedObjectContext: context)
            print("CoreDataSourceTests - Store successfully loaded. Data source succesfully created.")
        } catch {
            XCTFail("CoreDataSourceTests - Store failed to load \(error)")
            return
        }
        guard let dataSource = dataSource else {
            print("ERROR CoreDataSourceTests - trying to execute Act without store being loaded")
            return
        }
        let createPublisher: Future<Void, Error> = dataSource.create(
            parent: TransactionEntity.self,
            child: ImageEntity.self,
            parentModel: transaction1,
            childModel: image1,
            relationName: .image
        )
        let fetchPublisher: Future<[TransactionModel], Error> = dataSource.get(
            TransactionEntity.self,
            query: DatabaseQueryParemeters(
                predicate:  NSPredicate(format: "id = %@", transactionId1.uuidString)
            )
        )

        // Act and Assert
        do {
            let _ = try awaitPublisher(createPublisher.eraseToAnyPublisher())
            let storedObject = try awaitPublisher(fetchPublisher.eraseToAnyPublisher())
            guard let storedObject = storedObject.first else {
                XCTFail("CoreDataSourceTests - CREATE no stored objects")
                return
            }
            XCTAssertEqual(storedObject, transaction1)
        } catch {
            XCTFail("CoreDataSourceTests - CREATE should have succeeded")
        }
    }

}
