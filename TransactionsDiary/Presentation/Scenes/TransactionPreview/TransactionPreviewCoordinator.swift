//
//  TransactionPreviewCoordinator.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 4/3/25.
//

import SwiftUI
import UIKit

final class TransactionPreviewCoordinator: BaseFlowCoordinator {
    
    func createViewController(transactionId: UUID) -> UIViewController {
        let viewModel = TransactionPreviewViewModel(
            transactionId: transactionId,
            transactionService: diResolver.transactionService()
        )
        let view = TransactionPreviewView(
            viewModel: viewModel,
            coordinator: self
        )
        let viewController = UIHostingController(rootView: view)
        return viewController
    }
}
