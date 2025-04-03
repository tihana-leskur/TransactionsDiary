//
//  CoreDataRepositoryFactory.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 4/1/25.
//

import CoreData

final class CoreDataRepositoryFactory: DatabaseRepositoryFactory {
    private let dataSource: CoreDataSource

    init() async throws {
        let container = NSPersistentContainer(name: "TransactionDiary")
        let stream = AsyncThrowingStream<Void, Error> { continuation in
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    continuation.finish(throwing: error)
                } else {
                    continuation.yield()
                    continuation.finish()
                }
            })
        }
        try await stream.result()
        dataSource = CoreDataSource(managedObjectContext: container.viewContext)
    }

    func createTransactionRepository() -> TransactionRepository {
        DefaultTransactionRepository(databaseSource: dataSource)
    }
}

extension AsyncThrowingStream {
    func result() async throws -> Element? {
        var result: Element?
        for try await element in self {
            result = element
            break
        }
        return result
    }
}
