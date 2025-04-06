//
//  CoreDataDataSourceFactory.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 4/6/25.
//

import CoreData
import Foundation

final class CoreDataDataSourceFactory: DatabaseDataSourceFactory {
    let container: NSPersistentContainer
    private lazy var mainContext: NSManagedObjectContext = {
        let context = container.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }()

    init(inMemory: Bool) async throws {
        let container = NSPersistentContainer(name: "TransactionDiary")
        if inMemory {
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            container.persistentStoreDescriptions = [description]
        }
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
        self.container = container
    }

    func userInteractiveDataSource() -> DatabaseDataSource {
        CoreDataSource(managedObjectContext: mainContext)
    }

    func backgroundDataSource() -> DatabaseDataSource {
        CoreDataSource(managedObjectContext: container.newBackgroundContext())
    }
}
