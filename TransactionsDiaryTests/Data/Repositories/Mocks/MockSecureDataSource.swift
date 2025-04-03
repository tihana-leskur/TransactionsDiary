//
//  MockSecureDataSource.swift
//  TransactionsDiaryTests
//
//  Created by tihana leskur on 4/3/25.
//

import Combine
@testable import TransactionsDiary

final class MockSecureDataSource: SecureDataSource {
    var currentUser: User?
    var saveUserResult: Result<Void, Error> = .success(())

    func saveUser(_ user: User) -> Future<Void, Error> {
        Future<Void, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(DatabaseError.deallocated))
                return
            }
            switch self.saveUserResult {
            case .success:
                promise(.success(()))
            case .failure(let error):
                promise(.failure(error))
            }
        }
    }

    func getUser() throws -> User? {
        currentUser
    }
    
    func deleteUser(_ user: User) throws {}
}
