//
//  AppFlowCoordinator.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 3/31/25.
//

import Combine
import UIKit

final class AppFlowCoordinator {
    let window: UIWindow
    private let diResolver: DiResolver
    private let navigationController: UINavigationController
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(diResolver: DiResolver) {
        self.diResolver = diResolver
        
        let navigationController = Self.createRoot()
        self.navigationController = navigationController
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        let launchStateService = diResolver.launchStateService()
        subscribeToLaunchStateResolved(launchStateService)
        launchStateService.resolveLaunchState()
    }
    
    private func subscribeToLaunchStateResolved(
        _ launchStateService: LaunchStateService
    ) {
        launchStateService.launchState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state  in
                switch state {
                case .loggedIn:
                    self?.presentHome()
                case .loggedOut:
                    self?.presentHome()
                }
            }
            .store(in: &cancellables)
    }
    
    private func presentHome() {
        let coordinator = HomeCoordinator(
            navigationController: navigationController,
            diResolver: diResolver
        )
        let viewController = coordinator.createHomeViewController()
        navigationController.navigationBar.isHidden = true
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    static func createRoot() -> UINavigationController {
        // TODO: tihana set nav bar appearance from Theme
        let navigationController = UINavigationController()
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
       
        appearance.backButtonAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.black
        ]
        
        let navBar = navigationController.navigationBar
        navBar.standardAppearance = appearance
        navBar.scrollEdgeAppearance = appearance
        navBar.compactAppearance = appearance
        navBar.tintColor = .black
        navBar.isHidden = true
        
        navigationController.navigationItem.setHidesBackButton(true, animated: false)
        return navigationController
    }
}

