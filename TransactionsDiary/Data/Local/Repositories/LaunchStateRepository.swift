//
//  LaunchStateRepository.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 4/2/25.
//

import Foundation

protocol LaunchStateRepository {
    init(cacheDataSource: CacheDataSource)
    func isFirstLaunch() -> Bool
    func onboardingCompleted() -> Bool
}

final class DefaultLaunchStateRepository: LaunchStateRepository {
    private let cacheDataSource: CacheDataSource
    
    init(cacheDataSource: CacheDataSource) {
        self.cacheDataSource = cacheDataSource
    }

    func isFirstLaunch() -> Bool {
        let isLaunched: Bool? = cacheDataSource.getValue(for: .isFirstLaunch)
        if isLaunched == true {
            print("App already launched")
            return false
        } else {
            cacheDataSource.setValue(value: true, for: .isFirstLaunch)
            print("App launched first time")
            return true
        }
    }

    func onboardingCompleted() -> Bool {
        let result: Bool? = cacheDataSource.getValue(for: .onboardingCompleted)
        return result ?? false
    }
}
