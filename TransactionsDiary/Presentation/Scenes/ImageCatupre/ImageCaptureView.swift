//
//  ImageCaptureView.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 4/1/25.
//

import SwiftUI

struct ImageCaptureView: View {
    @ObservedObject var viewModel: ImageCaptureViewModel
    @State private var showSheet = false
    let coordinator: ImageCaptureFlow
    
    var body: some View {
        VStack {
            Spacer()
            Image(uiImage: viewModel.image)
                .resizable()
                .frame(width: 300, height: 300)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .aspectRatio(contentMode: .fit)
            Spacer()
            cameraActionButton()
            Spacer().frame(height: 30)
            confirmButton()
            Spacer()
        }
        .addBackgroundView()
        .sheet(isPresented: $showSheet) {
            ImagePicker(
                selectedImage: $viewModel.image,
                settings: viewModel.imagePickerSettings
            )
        }
        .interactiveDismissDisabled(true)
        .modifier(
            NavigationBarViewModifier(
                style: DefaultTheme().modalNavigationBarStyle(),
                onTap: { coordinator.dismiss() })
        )
    }
    @ViewBuilder
    private func cameraActionButton() -> some View {
        OnlyTextComponentView(
            item: .init(
                content: viewModel.cameraButtonState.content,
                textStyle: viewModel.cameraButtonState.isEnabled ?
                DefaultTheme().enabledButtonTextStyle() : DefaultTheme().disabledButtonTextStyle(),
                contentViewStyle: viewModel.cameraButtonState.isEnabled ?
                DefaultTheme().enabledButtonBackgroundStyle() : DefaultTheme().disabledButtonBackgroundStyle()
            ),
            height: 50,
            width: nil,
            textAlignement: .center,
            textPadding: 20,
            contentViewPadding: 16
        )
        .onTapGesture {
            showSheet.toggle()
        }
    }
    
    @ViewBuilder
    private func confirmButton() -> some View {
        OnlyTextComponentView(
            item: .init(
                content: viewModel.confirmButtonState.content,
                textStyle: viewModel.confirmButtonState.isEnabled ?
                DefaultTheme().enabledButtonTextStyle() : DefaultTheme().disabledButtonTextStyle(),
                contentViewStyle: viewModel.confirmButtonState.isEnabled ?
                DefaultTheme().enabledButtonBackgroundStyle() : DefaultTheme().disabledButtonBackgroundStyle()
            ),
            height: 50,
            width: nil,
            textAlignement: .center,
            textPadding: 20,
            contentViewPadding: 16
        ).onTapGesture {
            // TODO: tihana create button item in VM; publish item (contentLocalizedId, isEnabled, isVisible etc.)
            if viewModel.confirmButtonState.isEnabled {
                coordinator.goToNextScreen(viewModel.image)
            }
        }
    }
}
