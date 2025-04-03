//
//  NetworkReachabilityRepository.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 3/31/25.
//

import Combine
import Network

enum NetworkStatus {
    case wifi
    case cellular
    case none
    case unknown
}

protocol NetworkReachabilityRepository {
    var networkStatus: AnyPublisher<NetworkStatus, Never> { get }
    func getCurrentStatus() -> NetworkStatus
}

final class DefaultNetworkReachabilityRepository: NetworkReachabilityRepository {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkReachabilityRepository")
    private let networkStatusSubject: CurrentValueSubject<NetworkStatus, Never> = .init(.none)

    var networkStatus: AnyPublisher<NetworkStatus, Never> {
        networkStatusSubject.eraseToAnyPublisher()
    }

    func getCurrentStatus() -> NetworkStatus {
        networkStatusSubject.value
    }

    func startObservingNetworkStatus() {
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                if path.usesInterfaceType(.wifi) {
                    print("NetworkReachabilityRepository - WIFI connection is available.")
                    self?.networkStatusSubject.send(.wifi)
                } else if  path.usesInterfaceType(.cellular) {
                    print("NetworkReachabilityRepository - CELLULAR connection is available.")
                    self?.networkStatusSubject.send(.cellular)
                } else {
                    print("NetworkReachabilityRepository - UNKNOWN connection is available.")
                    self?.networkStatusSubject.send(.unknown)
                }
            } else {
                print("NetworkReachabilityRepository - Internet connection is not available.")
                self?.networkStatusSubject.send(.none)
            }
        }
        monitor.start(queue: queue)
    }
}
