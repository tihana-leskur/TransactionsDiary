//
//  CoreDataSource.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 3/30/25.
//

import Combine
import CoreData
import Foundation

final class CoreDataSource: DatabaseDataSource {
    private let managedObjectContext: NSManagedObjectContext
    private var cancellables: Set<AnyCancellable> = .init()

    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }

    func createMultiple<Parent: DomainModelMappable, Child: DomainModelMappable>(
        parent: Parent.Type,
        child: Child.Type,
        parentModels: [any DomainModel],
        childModels: [any DomainModel],
        relationName: RelationName
    ) -> Future<Void, Error> {
        Future<Void, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(DatabaseError.deallocated))
                return
            }
            Task { [weak self] in
                do {
                    try await self?.performMultipleSaveOnContext(
                        parent: parent,
                        child: child,
                        parentModels: parentModels as! [Parent.DomainModel],
                        childModels: childModels as! [Child.DomainModel],
                        relationName: relationName
                    )
                    promise(.success(()))
                } catch {
                    promise(.failure(DatabaseError.createFailed))
                }
            }
        }
    }

    func create<Parent: DomainModelMappable, Child: DomainModelMappable>(
        parent: Parent.Type,
        child: Child.Type,
        parentModel: any DomainModel,
        childModel: any DomainModel,
        relationName: RelationName
    ) -> Future<Void, Error> {
        Future<Void, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(DatabaseError.deallocated))
                return
            }
            guard let parentDomainModel = parentModel as? Parent.DomainModel,
                  let childDomainModel = childModel as? Child.DomainModel else {
                promise(.failure(DatabaseError.invalidEntityType))
                return
            }
            do {
                try self.managedObjectContext.performAndWait {
                    // create parent
                    let parentClassName = String(describing: Parent.self)
                    guard let parentManagedObject = NSEntityDescription.insertNewObject(
                        forEntityName: parentClassName,
                        into: self.managedObjectContext
                    ) as? Parent else {
                        promise(.failure(DatabaseError.invalidEntityType))
                        return
                    }
                    parentManagedObject.fromDomainModel(parentDomainModel)
                    // create child
                    let childClassName = String(describing: Child.self)
                    guard let childManagedObject = NSEntityDescription.insertNewObject(
                        forEntityName: childClassName,
                        into: self.managedObjectContext
                    ) as? Child else {
                        promise(.failure(DatabaseError.invalidEntityType))
                        return
                    }
                    childManagedObject.fromDomainModel(childDomainModel)
                    // add relationship
                    (parentManagedObject as? NSManagedObject)?
                        .setValue(childManagedObject, forKey: relationName.rawValue)
                    // save
                    try self.managedObjectContext.save()
                    promise(.success(()))
                }
            } catch {
                promise(.failure(DatabaseError.createFailed))
            }
        }
    }
    
    func get<T: DomainModelMappable>(
        _ entity: T.Type,
        query: DatabaseQueryParemeters?
    ) -> Future<[T.DomainModel], Error> {
        Future<[T.DomainModel], Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(DatabaseError.deallocated))
                return
            }
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: entity.self))
            fetchRequest.predicate = query?.predicate
            fetchRequest.sortDescriptors = query?.sortDescriptors
            if let fetchOffset = query?.fetchOffset,
               let fetchLimit = query?.fetchLimit {
                fetchRequest.fetchOffset = fetchOffset
                fetchRequest.fetchLimit = fetchLimit
            }
            Task { [weak self] in
                do {
                    let result = try await self?.performFetchOnContext(
                        entity,
                        fetchRequest: fetchRequest
                    ) ?? []
                    promise(.success(result))
                } catch {
                    promise(.failure(DatabaseError.fetchFailed))
                }
                
            }
        }
    }
}

// MARK: - CoreDataSource + Perform Utils
private extension CoreDataSource {
    func performMultipleSaveOnContext<Parent: DomainModelMappable, Child: DomainModelMappable>(
        parent: Parent.Type,
        child: Child.Type,
        parentModels: [Parent.DomainModel],
        childModels: [Child.DomainModel],
        relationName: RelationName
    ) async throws {
        try await self.managedObjectContext.perform {
            try zip(parentModels, childModels).forEach { (parentModel, childModel) in
                // create parent
                let parentClassName = String(describing: Parent.self)
                guard let parentManagedObject = NSEntityDescription.insertNewObject(
                    forEntityName: parentClassName,
                    into: self.managedObjectContext
                ) as? Parent else {
                    throw DatabaseError.invalidEntityType
                }
                parentManagedObject.fromDomainModel(parentModel)
                // create child
                let childClassName = String(describing: Child.self)
                guard let childManagedObject = NSEntityDescription.insertNewObject(
                    forEntityName: childClassName,
                    into: self.managedObjectContext
                ) as? Child else {
                    throw DatabaseError.invalidEntityType
                }
                childManagedObject.fromDomainModel(childModel)
                // add relationship
                (parentManagedObject as? NSManagedObject)?
                    .setValue(childManagedObject, forKey: relationName.rawValue)
            }
            
            // save
            try self.managedObjectContext.save()
        }
    }

    func performFetchOnContext<T: DomainModelMappable>(
        _ entity: T.Type,
        fetchRequest: NSFetchRequest<NSFetchRequestResult>
    ) async throws -> [T.DomainModel] {
        try await managedObjectContext.perform { [weak self] in
            do {
                if let fetchResults = try self?.managedObjectContext.fetch(fetchRequest) as? [T] {
                    return fetchResults.map {
                        $0.toDomainModel()
                    }
                } else {
                    throw DatabaseError.invalidEntityType
                }
            } catch {
                throw error
            }
        }
    }
}
