//
//  MockDatabaseDataSource.swift
//  TransactionsDiaryTests
//
//  Created by tihana leskur on 4/3/25.
//

import Combine
@testable import TransactionsDiary

struct MockDatabaseDataSourceContext: DatabaseDataSourceContext {}

final class MockDatabaseDataSource: DatabaseDataSource {
    var context: DatabaseDataSourceContext {
        MockDatabaseDataSourceContext()
    }

    var createMultipleResult: Result<Void, DatabaseError> = .failure(.deallocated)
    var createResult: Result<Void, DatabaseError> = .failure(.deallocated)
    var getResult: Result<[any DomainModel], DatabaseError> = .failure(.deallocated)
    var usedFetchQuery: DatabaseQueryParemeters?

    func createMultiple<Parent, Child>(
        parent: Parent.Type,
        child: Child.Type,
        parentModels: [any DomainModel],
        childModels: [any DomainModel],
        relationName: RelationName
    ) -> Future<Void, Error> where Parent : DomainModelMappable, Child : DomainModelMappable {
        Future<Void, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(DatabaseError.deallocated))
                return
            }
            switch self.createMultipleResult {
            case .success:
                promise(.success(()))
            case .failure(let error):
                promise(.failure(error))
            }
        }
    }
    
    func create<Parent, Child>(
        parent: Parent.Type,
        child: Child.Type,
        parentModel: any DomainModel,
        childModel: any DomainModel,
        relationName: RelationName
    ) -> Future<Void, Error> where Parent : DomainModelMappable, Child : DomainModelMappable {
        Future<Void, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(DatabaseError.deallocated))
                return
            }
            switch self.createResult {
            case .success:
                promise(.success(()))
            case .failure(let error):
                promise(.failure(error))
            }
        }
    }
    
    func get<T>(
        _ entity: T.Type,
        query: DatabaseQueryParemeters?
    ) -> Future<[T.DomainModel], Error> where T : DomainModelMappable {
        Future<[T.DomainModel], Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(DatabaseError.deallocated))
                return
            }
            self.usedFetchQuery = query
            switch self.getResult {
            case .success(let models):
                promise(.success(models as? [T.DomainModel] ?? []))
            case .failure(let error):
                promise(.failure(error))
            }
        }
    }
}
