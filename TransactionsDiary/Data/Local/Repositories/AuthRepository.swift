//
//  AuthRepository.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 4/2/25.
//

import Combine
import Foundation

protocol AuthRepository {
    init(
        secureDataSource: SecureDataSource,
        remoteDataSource: AuthRemoteDataSource
    )
    func saveUser(_ user: User) -> Future<Void, Error>
    func loggedInUser() throws -> User?
}

final class DefaultAuthRepository: AuthRepository {
    private let secureDataSource: SecureDataSource
    private let remoteDataSource: AuthRemoteDataSource

    init(
        secureDataSource: SecureDataSource,
        remoteDataSource: AuthRemoteDataSource
    ) {
        self.secureDataSource = secureDataSource
        self.remoteDataSource = remoteDataSource
    }

    func saveUser(_ user: User) -> Future<Void, Error> {
        secureDataSource.saveUser(user)
    }

    func loggedInUser() throws -> User? {
        try secureDataSource.getUser()
    }
}
