//
//  HomeCoordinator.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 3/31/25.
//

import UIKit
import SwiftUI

final class HomeCoordinator: BaseFlowCoordinator {

    func createHomeViewController() -> UIViewController {
        let viewModel = HomeViewModel(
            transactionService: diResolver.transactionService()
        )
        let view = HomeView(viewModel: viewModel, coordinator: self)
        let viewController = UIHostingController(rootView: view)
        viewController.navigationItem.setHidesBackButton(true, animated: false)
        return viewController
    }

    func syncNavigationBarVisibility() {
        navigationController.navigationBar.isHidden = true
    }

    func showAllTransactions() {
        let coordinator = TransactionsListCoordinator(
            navigationController: navigationController,
            diResolver: diResolver
        )
        let viewController = coordinator.createTransactionsListViewController()
        viewController.navigationItem.setHidesBackButton(true, animated: false)
        navigationController.navigationBar.isHidden = false
        navigationController.pushViewController(viewController, animated: true)
    }

    func startAddTransaction(_ transactionType: TransactionType) {
        let coordinator = AddTransactionCoordinator(
            navigationController: navigationController,
            diResolver: diResolver
        )
        coordinator.start(type: transactionType)
    }
}

