//
//  AddTransactionCoordinator.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 4/2/25.
//

import SwiftUI
import UIKit

final class AddTransactionCoordinator: BaseFlowCoordinator, ImageCaptureFlow {
    private var flowNavigationStack: UINavigationController?
    private var type: TransactionType = .invoice

    func start(type: TransactionType) {
        flowNavigationStack = createFlowNavigationStack()
        self.type = type

        guard let flowNavigationStack = flowNavigationStack else {
            print("ERROR AddTransactionCoordinator - did not create child navigation stack. No action will be performed.")
            return
        }
        let viewController = createImageCaptureViewController(
            settings: .cameraWithoutEditing
        )
        flowNavigationStack.setViewControllers(
            [viewController],
            animated: false
        )
        navigationController.present(flowNavigationStack, animated: true)
    }
    
    private func createFlowNavigationStack() -> UINavigationController {
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
        
        navBar.isHidden = false
        navigationController.modalPresentationStyle = .pageSheet
        navigationController.navigationItem.setHidesBackButton(true, animated: true)
        return navigationController
    }

    func goToNextScreen(_ image: UIImage) {
        let viewModel = AddTransactionViewModel(
            transactionService: diResolver.transactionService(),
            coordinator: self,
            type: type,
            image: image
        )
        let view = AddTransactionView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        flowNavigationStack?.pushViewController(viewController, animated: true)
    }

    override func dismiss(animated: Bool = true) {
        flowNavigationStack?.dismiss(animated: true) { [weak self] in
            self?.flowNavigationStack = nil
        }
    }
}
