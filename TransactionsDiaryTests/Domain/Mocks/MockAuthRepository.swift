//
//  MockAuthRepository.swift
//  TransactionsDiaryTests
//
//  Created by tihana leskur on 4/3/25.
//

import Combine
import Foundation
@testable import TransactionsDiary

final class MockAuthRepository: AuthRepository {
    var saveUserResult: Result<Void, Error> = .success(())
    var currentUser: User?

    init(
        secureDataSource: SecureDataSource,
        remoteDataSource: AuthRemoteDataSource
    ) {}
    
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

    func loggedInUser() throws -> User? {
        currentUser
    }
}
