//
//  SecureDataSource.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 3/31/25.
//

import Combine
import Foundation

protocol SecureDataSource {
    func saveUser(_ user: User) -> Future<Void, Error>
    func getUser() throws -> User?
    func deleteUser(_ user: User) throws
}

enum SecureDataSourceError: LocalizedError {
    case badValue
    case storeFailed
    case fetchFailed
}

// TODO: use Keychain / KeychainWrapper
final class KeychainDataSource: SecureDataSource {
    func saveUser(_ user: User) -> Future<Void, Error> {
        Future<Void, Error> { promise in
            UserDefaults.standard.setValue(user.id.uuidString, forKey: "userId")
            UserDefaults.standard.setValue(user.password, forKey: "password")
            promise(.success(()))
        }
    }
    
    func getUser() throws -> User? {
        guard let id = UserDefaults.standard.string(forKey: "userId"),
              let password = UserDefaults.standard.string(forKey: "password") else {
            return nil
        }
        return User(
            id: UUID(uuidString: id) ?? UUID(),
            password:  password
        )
    }

    func deleteUser(_ user: User) throws {
        UserDefaults.standard.removeObject(forKey: "userId")
        UserDefaults.standard.removeObject(forKey: "password")
    }
}
