//
//  MockNetworkStatusRepository.swift
//  TransactionsDiaryTests
//
//  Created by tihana leskur on 4/3/25.
//

import Combine
import Foundation
@testable import TransactionsDiary

final class MockNetworkReachabilityRepository: NetworkReachabilityRepository {
    var currentNetworkStatus: NetworkStatus = .unknown
    var updateSubject: PassthroughSubject<NetworkStatus, Never> = .init()

    var networkStatus: AnyPublisher<NetworkStatus, Never> {
        updateSubject.eraseToAnyPublisher()
    }
    
    func getCurrentStatus() -> NetworkStatus {
        currentNetworkStatus
    }
}
