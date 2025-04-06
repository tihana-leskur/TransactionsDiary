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
    private let remoteDataSource: RemoteDataSource
    private let databaseDataSourceFactory: DatabaseDataSourceFactory
    private let _authRepository: AuthRepository
    private let _networkReachabilityRepository: NetworkReachabilityRepository
    private let _transactionRepository: TransactionRepository

    init(
        databaseType: DatabaseType,
        httpClientType: HttpClientType
    ) async throws {
        switch databaseType {
        case .coreData:
            databaseDataSourceFactory = try await CoreDataDataSourceFactory(inMemory: false)
        }
        switch httpClientType {
        case .urlSession:
            remoteDataSource = DefaultRemoteDataSource(httpClient: UrlSessionHttpClient())
        }
        self._networkReachabilityRepository = DefaultNetworkReachabilityRepository()
        self._authRepository = DefaultAuthRepository(
            secureDataSource: KeychainDataSource(),
            remoteDataSource: remoteDataSource
        )
        self._transactionRepository = DefaultTransactionRepository(
            databaseSource: databaseDataSourceFactory.userInteractiveDataSource()
        )
    }

    func launchStateService() -> LaunchStateService {
        DefaultLaunchStateService(
            authRepository: _authRepository,
            launchStateRepository: DefaultLaunchStateRepository(
                cacheDataSource: UserDefaults.standard
            ),
            remoteDataSource: remoteDataSource,
            transactionRepository: DefaultTransactionRepository(
                databaseSource: databaseDataSourceFactory.backgroundDataSource()
            )
        )
    }

    func transactionService() -> TransactionService {
        DefaultTransactionService(
            transactionRepository: _transactionRepository,
            remoteDataSource: remoteDataSource,
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
