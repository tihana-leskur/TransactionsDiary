//
//  ImagePickerSettings.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 4/2/25.
//

import UIKit

struct ImagePickerSettings {
    let sourceType: UIImagePickerController.SourceType
    let allowsEditing: Bool
    
    static let cameraWithoutEditing = ImagePickerSettings(
        sourceType: .camera,
        allowsEditing: false
    )
}
