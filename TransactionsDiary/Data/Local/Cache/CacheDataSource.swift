//
//  UserDefaultsDataSource.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 3/30/25.
//

import Foundation

enum CacheKeys: String {
    case isFirstLaunch
    case onboardingCompleted
}

protocol CacheDataSource {
    func setValue<T>(value: T, for key: CacheKeys)
    func getValue<T>(for key: CacheKeys) -> T?
}

enum CacheError: Error {
    case invalidValueType
}

// MARK: - UserDefaults + CacheDataSource
extension UserDefaults: CacheDataSource {

    func setValue<T>(value: T, for key: CacheKeys) {
        setValue(value, forKey: key.rawValue)
    }

    func getValue<T>(for key: CacheKeys) -> T? {
        value(forKey: key.rawValue) as? T
    }
}
