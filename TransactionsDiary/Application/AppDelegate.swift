//
//  AppDelegate.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 3/31/25.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var appFlowCoordinator: AppFlowCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let isUnitTesting = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
        guard !isUnitTesting else {
            return true
        }
        Task {
            do {
                let diResolver = try await DefaultDiResolver(databaseType: .coreData)
                appFlowCoordinator = AppFlowCoordinator(diResolver: diResolver)
            } catch {
                print("ERROR App Launch - Dependencies could not be resolved!")
            }
        }

        return true
    }
}

