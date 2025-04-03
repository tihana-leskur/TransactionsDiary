//
//  LaunchStateService.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 4/2/25.
//

import Combine
import Foundation // demo initial data set up

enum LaunchState {
    case loggedIn
    case loggedOut
}

protocol LaunchStateService {
    init(
        authRepository: AuthRepository,
        launchStateRepository: LaunchStateRepository,
        remoteDataSource: AuthRemoteDataSource,
        transactionRepository: TransactionRepository
    )
    var launchState: AnyPublisher<LaunchState, Never> { get }
    func resolveLaunchState()
}

final class DefaultLaunchStateService: LaunchStateService {
    private let authRepository: AuthRepository
    private let launchStateRepository: LaunchStateRepository
    private let remoteDataSource: AuthRemoteDataSource
    private let transactionRepository: TransactionRepository
    private let launchStateSubject: PassthroughSubject<LaunchState, Never> = .init()
    private var cancellables: Set<AnyCancellable> = .init()

    var launchState: AnyPublisher<LaunchState, Never> {
        launchStateSubject.eraseToAnyPublisher()
    }

    init(
        authRepository: AuthRepository,
        launchStateRepository: LaunchStateRepository,
        remoteDataSource: AuthRemoteDataSource,
        transactionRepository: TransactionRepository
    ) {
        self.authRepository = authRepository
        self.launchStateRepository = launchStateRepository
        self.remoteDataSource = remoteDataSource
        self.transactionRepository = transactionRepository
    }

    func resolveLaunchState() {
        if launchStateRepository.isFirstLaunch() {
            syncData()
        } else {
            launchStateSubject.send(.loggedIn)
        }
    }
    
    private func syncData() {
        let userId = UUID()
        Publishers.Merge(
            authRepository.saveUser(User(id: userId, password: "test123")),
            transactionRepository.createTransactions(demoData(), for: userId)
        )
        .sink { _ in } receiveValue: { [weak self] _ in
            self?.launchStateSubject.send(.loggedIn)
        }
        .store(in: &cancellables)
    }
}

// MARK: - Demo set up
func demoData() -> [TransactionDetails] {
    var result: [TransactionDetails] = []
    for i in 0..<100 {
        let transaction = TransactionDetails(
            id: UUID(),
            name: "transaction\(i)",
            timestamp: Date().timeIntervalSince1970,
            amount: 20,
            currency: Currency.eur,
            type: TransactionType.invoice,
            imageId: UUID(),
            imageData: Data()
        )
        result.append(transaction)
    }
    return result
}
