//
//  ImageCaptureFlow.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 4/1/25.
//

import SwiftUI
import UIKit

// Image Capture can be part of any flow which
// determines it's meaning and further actions.
protocol ImageCaptureFlow: BaseFlowCoordinator {
    func goToNextScreen(_ image: UIImage)
    func createImageCaptureViewController(
        settings: ImagePickerSettings
    ) -> UIViewController
}

extension ImageCaptureFlow {
    func createImageCaptureViewController(
        settings: ImagePickerSettings
    ) -> UIViewController {
        let view = ImageCaptureView(
            viewModel: ImageCaptureViewModel(settings: settings),
            coordinator: self
        )
        let viewController = UIHostingController(rootView: view)
        return viewController
    }
}
