//
//  TransactionsListCoordinator.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 3/31/25.
//

import UIKit
import SwiftUI

final class TransactionsListCoordinator: BaseFlowCoordinator {

    func createTransactionsListViewController() -> UIViewController {
        let viewModel = TransactionsListViewModel(
            transactionsService: diResolver.transactionService()
        )
        let view = TransactionsListView(
            viewModel: viewModel,
            coordinator: self
        )
        let viewController = UIHostingController(rootView: view)
        return viewController
    }

    func showTransactionDetails(id: UUID) {
        let coordinator = TransactionPreviewCoordinator(
            navigationController: navigationController,
            diResolver: diResolver
        )
        let viewController = coordinator.createViewController(transactionId: id)
        viewController.navigationItem.setHidesBackButton(true, animated: false)
        navigationController.navigationBar.isHidden = false
        navigationController.pushViewController(viewController, animated: true)
    }
}
