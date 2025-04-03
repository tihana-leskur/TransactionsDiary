//
//  DiResolver.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 3/31/25.
//

import Foundation

protocol DiResolver {
    // Services
    func launchStateService() -> LaunchStateService
    func transactionService() -> TransactionService
    // Repositories
    func authRepository() -> AuthRepository
    func networkReachabilityRepository() -> NetworkReachabilityRepository
}

final class DefaultDiResolver: DiResolver {
    private let httpClient: HttpClient
    private let databaseRepositoryFactory: DatabaseRepositoryFactory
    private let _authRepository: AuthRepository
    private let _networkReachabilityRepository: NetworkReachabilityRepository
    private let _transactionRepository: TransactionRepository

    init(databaseType: DatabaseType) async throws {
        switch databaseType {
        case .coreData:
            databaseRepositoryFactory =  try await CoreDataRepositoryFactory()
        }
        self.httpClient = UrlSessionHttpClient()
        self._networkReachabilityRepository = DefaultNetworkReachabilityRepository()
        self._authRepository = DefaultAuthRepository(
            secureDataSource: KeychainDataSource(),
            remoteDataSource: DefaultRemoteDataSource(httpClient: httpClient)
        )
        self._transactionRepository = databaseRepositoryFactory.createTransactionRepository()
    }

    func launchStateService() -> LaunchStateService {
        DefaultLaunchStateService(
            authRepository: _authRepository,
            launchStateRepository: DefaultLaunchStateRepository(
                cacheDataSource: UserDefaults.standard
            ),
            remoteDataSource: DefaultRemoteDataSource(
                httpClient: httpClient
            ),
            transactionRepository: databaseRepositoryFactory.createTransactionRepository()
        )
    }

    func transactionService() -> TransactionService {
        DefaultTransactionService(
            transactionRepository: _transactionRepository,
            remoteDataSource: DefaultRemoteDataSource(
                httpClient: httpClient
            ),
            authRepository: _authRepository,
            networkReachabilityRepository: _networkReachabilityRepository
        )
    }

    func authRepository() -> AuthRepository {
        _authRepository
    }

    func networkReachabilityRepository() -> NetworkReachabilityRepository {
        _networkReachabilityRepository
    }
}
