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

    @Published var image: UIImage = UIImage() {
        didSet {
            confirmButtonState.isEnabled = true
            cameraButtonState.content = Strings.retakePhoto
        }
    }
    @Published var cameraButtonState = ButtonItem(
        content: Strings.takePhoto,
        isEnabled: true
    )
    @Published var confirmButtonState = ButtonItem(
        content: Strings.confirmAction,
        isEnabled: true
    )

    init(settings: ImagePickerSettings) {
        self.imagePickerSettings = settings
    }
}
