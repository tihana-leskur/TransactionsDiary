//
//  TransactionService.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 3/30/25.
//

import Combine
import Foundation

// MARK: - TransactionService
protocol TransactionService {
    init(
        transactionRepository: TransactionRepository,
        remoteDataSource: TransactionRemoteDataSource,
        authRepository: AuthRepository,
        networkReachabilityRepository: NetworkReachabilityRepository
    )
    func addTransaction(_ transaction: TransactionDetails) -> AnyPublisher<Void, Error>
    func getAllTransactions() -> Future<[Transaction], Error>
    func getLastTransactions(count: Int) -> Future<[Transaction], Error>
    func getTransactionDetails(id: UUID) -> Future<TransactionDetails, Error>
    func getTransactions(from index: Int, batchSize: Int) -> Future<[Transaction], Error>
}

// MARK: - DefaultTransactionService
final class DefaultTransactionService: TransactionService {
    private let transactionRepository: TransactionRepository
    private let remoteDataSource: TransactionRemoteDataSource
    private let authRepository: AuthRepository
    private var networkStatus: NetworkStatus
    private var cancellables: Set<AnyCancellable> = .init()

    init(
        transactionRepository: TransactionRepository,
        remoteDataSource: TransactionRemoteDataSource,
        authRepository: AuthRepository,
        networkReachabilityRepository: NetworkReachabilityRepository
    ) {
        self.transactionRepository = transactionRepository
        self.remoteDataSource = remoteDataSource
        self.authRepository = authRepository
        networkStatus = networkReachabilityRepository.getCurrentStatus()
        subscribeToNetworkStatusUpdates(
            networkReachabilityRepository: networkReachabilityRepository
        )
    }

    private func subscribeToNetworkStatusUpdates(
        networkReachabilityRepository: NetworkReachabilityRepository
    ) {
        networkReachabilityRepository.networkStatus
            .sink { [weak self] status in
                self?.networkStatus = status
            }
            .store(in: &cancellables)
    }

    func addTransaction(
        _ transaction: TransactionDetails
    ) -> AnyPublisher<Void, Error> {
        do {
            guard let userId = try authRepository.loggedInUser()?.id else {
                return AnyPublisher<[Transaction], RequestError>.failedRequest()
            }
            return syncUploadWithRemoteDataSource(
                userId: userId,
                transaction
            )
        } catch {
            return AnyPublisher<[Transaction], RequestError>.failedRequest()
        }
    }

    func getAllTransactions() -> Future<[Transaction], Error> {
        do {
            guard let userId = try authRepository.loggedInUser()?.id else {
                return Future<[Transaction], RequestError>.failedFuture()
            }
            return transactionRepository.getTransactions(
                userId: userId,
                parameters: .empty
            )
        } catch {
            return Future<[Transaction], RequestError>.failedFuture()
        }
    }

    func getLastTransactions(count: Int) -> Future<[Transaction], Error> {
        do {
            guard let userId = try authRepository.loggedInUser()?.id else {
                return Future<[Transaction], RequestError>.failedFuture()
            }
            return transactionRepository.getTransactions(
                userId: userId,
                parameters: .init(fetchLimit: count)
            )
        } catch {
            return Future<[Transaction], RequestError>.failedFuture()
        }
    }

    func getTransactionDetails(id: UUID) -> Future<TransactionDetails, Error> {
        transactionRepository.getTransactionDetails(id: id)
    }

    func getTransactions(
        from index: Int,
        batchSize: Int
    ) -> Future<[Transaction], Error> {
        do {
            guard let userId = try authRepository.loggedInUser()?.id else {
                return Future<[Transaction], RequestError>.failedFuture()
            }
            return transactionRepository.getTransactions(
                userId: userId,
                parameters: RepositoryQueryParameters(
                    fetchOffset: index,
                    fetchLimit: batchSize
                )
            )
        } catch {
            return Future<[Transaction], RequestError>.failedFuture()
        }
    }
}

// MARK: Source Management
private extension DefaultTransactionService {

    func syncUploadWithRemoteDataSource(
        userId: UUID,
        _ transaction: TransactionDetails
    ) -> AnyPublisher<Void, Error> {
        guard shouldSyncWithRemote() else {
            return storeInLocalStorage(userId: userId, transaction)
                .eraseToAnyPublisher()
        }

        return remoteDataSource
            .addTransaction(transaction)
            .flatMap { [weak self] _ in
                guard let self = self else {
                    return Future<Any, RequestError>.failedFutureVoid()
                }
                return self.storeInLocalStorage(
                    userId: userId,
                    transaction
                )
            }
            .eraseToAnyPublisher()
    }

    func shouldSyncWithRemote() -> Bool {
        // user preferences automatic uploads, only wifi, only cellular...
        networkStatus == .cellular || networkStatus == .wifi
    }

    func storeInLocalStorage(
        userId: UUID,
        _ transaction: TransactionDetails
    ) -> Future<Void, Error> {
        transactionRepository.createTransaction(
            transaction,
            for: userId
        )
    }

    func syncDeleteWithRemoteDataSource() -> Bool {
        // user preferences keep past transactions on remote storage
        networkStatus == .cellular || networkStatus == .wifi
    }
}

// TODO: tihana move to dedicated file
enum RequestError: Error {
    case conditionsNotMet
    case moduleDeallocated
}

extension Future {
    static func failedFuture<T>() -> Future<T, Error> {
        Future<T, Error> { promise in
            promise(.failure(RequestError.conditionsNotMet))
        }
    }
    
    static func failedFutureVoid() -> Future<Void, Error> {
        Future<Void, Error> { promise in
            promise(.failure(RequestError.conditionsNotMet))
        }
    }
}

extension AnyPublisher {
    static func failedRequest<T>() -> AnyPublisher<T, Error> {
        Future<T, Error> { promise in
            promise(.failure(RequestError.conditionsNotMet))
        }
        .eraseToAnyPublisher()
    }
}
