//
//  BaseFlowCoordinator.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 3/31/25.
//

import UIKit

class BaseFlowCoordinator: NSObject {
    let navigationController: UINavigationController
    let diResolver: DiResolver

    init(
        navigationController: UINavigationController,
        diResolver: DiResolver
    ) {
        self.navigationController = navigationController
        self.diResolver = diResolver
    }

    func popToRootNavigationController(animated: Bool = true) {
        navigationController.popToRootViewController(animated: animated)
    }

    func goBack(animated: Bool = true) {
        navigationController.popViewController(animated: animated)
    }

    func dismiss(animated: Bool = true) {
        navigationController.dismiss(animated: animated)
    }
}

