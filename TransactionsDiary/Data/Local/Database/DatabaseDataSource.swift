//
//  Repository.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 3/30/25.
//

import Combine
import Foundation

// MARK: - DatabaseQueryParemeters
struct DatabaseQueryParemeters {
    let predicate: NSPredicate?
    let sortDescriptors: [NSSortDescriptor]
    let fetchOffset: Int?
    let fetchLimit: Int?

    init(
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor] = [],
        fetchOffset: Int? = nil,
        fetchLimit: Int? = nil
    ) {
        self.predicate = predicate
        self.sortDescriptors = sortDescriptors
        self.fetchOffset = fetchOffset
        self.fetchLimit = fetchLimit
    }
}

// MARK: - DatabaseError
enum DatabaseError: Error {
    case deallocated
    case invalidEntityType
    case createFailed
    case fetchFailed
}

// MARK: - RelationName
enum RelationName: String {
    case image
}

// MARK: - DatabaseDataSourceContext
protocol DatabaseDataSourceContext {}

// MARK: - DatabaseDataSource
protocol DatabaseDataSource {
    var context: DatabaseDataSourceContext { get }
    func createMultiple<Parent: DomainModelMappable, Child: DomainModelMappable>(
        parent: Parent.Type,
        child: Child.Type,
        parentModels: [any DomainModel],
        childModels: [any DomainModel],
        relationName: RelationName
    ) -> Future<Void, Error>

    func create<Parent: DomainModelMappable, Child: DomainModelMappable>(
        parent: Parent.Type,
        child: Child.Type,
        parentModel: any DomainModel,
        childModel: any DomainModel,
        relationName: RelationName
    ) -> Future<Void, Error>

    func get<T: DomainModelMappable>(
        _ entity: T.Type,
        query: DatabaseQueryParemeters?
    ) -> Future<[T.DomainModel], Error>

    // update, delete
}
