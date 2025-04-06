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

final class CoreDataSourceTests: CoreDataTest {
    var persistentContainer: NSPersistentContainer?

    override func setUp() {
        continueAfterFailure = false
    }

    func testCreate() throws {
        // Arrange
        let transactionId = UUID()
        let imageId = UUID()
        let transaction = createTransaction(id: transactionId)
        let image = createImage(id: imageId)
        let transactionFetchRequest: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        transactionFetchRequest.predicate = NSPredicate(format: "id == %@", transactionId.uuidString)
        let imageFetchRequest: NSFetchRequest<ImageEntity> = ImageEntity.fetchRequest()
        imageFetchRequest.predicate = NSPredicate(format: "transaction.id = %@", transactionId.uuidString)
        
        // Act
        guard let sut = getDataSourceOrFail(),
               let context = sut.context as? NSManagedObjectContext
        else {
            XCTFail("ERROR CoreDataSourceTests - invalid context in data source")
            return
        }
        let createPublisher: Future<Void, Error> = sut.create(
            parent: TransactionEntity.self,
            child: ImageEntity.self,
            parentModel: transaction,
            childModel: image,
            relationName: .image
        )

        do {
            let _ = try awaitPublisher(createPublisher.eraseToAnyPublisher())
        } catch {
            XCTFail("CoreDataSourceTests - CREATE should have succeeded. Error: \(error)")
        }

        // Assert
        do {
            try context.performAndWait {
                guard let transactionStoredObject = try context.fetch(transactionFetchRequest).first,
                      let imageStoredObject = try context.fetch(imageFetchRequest).first else {
                    throw DatabaseError.fetchFailed
                }
                let storedTransactionModel = transactionStoredObject.toDomainModel()
                XCTAssertEqual(storedTransactionModel, transaction)
                let storedImageModel = imageStoredObject.toDomainModel()
                XCTAssertEqual(storedImageModel, image)
            }
        } catch {
            XCTFail("CoreDataSourceTests - CREATE should have succeeded. Error: \(error)")
        }
    }
    
    // MARK: - Utils

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

    private func getDataSourceOrFail() -> CoreDataSource? {
        do {
            let _ = try awaitPublisher(loadStore().eraseToAnyPublisher())
            guard let context = persistentContainer?.newBackgroundContext() else {
                XCTFail("CoreDataSourceTests - Store failed to load")
                return nil
            }
            print("CoreDataSourceTests - Store successfully loaded. Data source succesfully created.")
            return CoreDataSource(managedObjectContext: context)
        } catch {
            XCTFail("CoreDataSourceTests - Store failed to load \(error)")
            return nil
        }
    }
}
