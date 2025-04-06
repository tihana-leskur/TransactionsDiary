//
//  ImageCaptureViewModel.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 4/2/25.
//

import SwiftUI
import UIKit

final class ImageCaptureViewModel: ObservableObject {
    let imagePickerSettings: ImagePickerSettings
    // TODO: tihana localize me
    let title = "Take Transaction Image"

    @Published var image: UIImage = UIImage() {
        didSet {
            confirmButtonState = ButtonItem(
                content: "Confirm",
                isEnabled: true
            )
            cameraButtonState = ButtonItem(
                content: "Retake Photo",
                isEnabled: true
            )
        }
    }
    @Published var cameraButtonState = ButtonItem(
        content: "Take Photo",
        isEnabled: true
    )
    @Published var confirmButtonState = ButtonItem(
        content: "Confirm",
        isEnabled: true
    )

    init(settings: ImagePickerSettings) {
        self.imagePickerSettings = settings
    }
}
