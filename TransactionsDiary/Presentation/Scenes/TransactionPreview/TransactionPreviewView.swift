//
//  TransactionPreviewView.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 4/3/25.
//

import SwiftUI

struct TransactionPreviewView: View {
    @ObservedObject var viewModel: TransactionPreviewViewModel
    let coordinator: TransactionPreviewCoordinator

    var body: some View {
        VStack {
            Spacer().frame(height: 10)
            Image(uiImage: viewModel.image)
                .resizable()
                .frame(width: 300, height: 300)
                .background(Color.gray.opacity(0.2))
                .aspectRatio(contentMode: .fit)
            Spacer().frame(height: 10)
            amount()
            Spacer().frame(height: 10)
            date()
            Spacer().frame(height: 10)
            currency()
            Spacer()
        }
        .addBackgroundView()
        .modifier(
            NavigationBarViewModifier(
                style: DefaultTheme().navigationBarStyle(),
                onTap: { coordinator.goBack() }
            ))
        .onWillAppear {
            viewModel.viewWillAppear()
        }
    }

    @ViewBuilder
    private func amount() -> some View {
        Text(viewModel.amount)
            .modifier(
                TextViewModifier(style: DefaultTheme().primaryTextStyle())
            )
            .padding([.horizontal], 16)
    }

    @ViewBuilder
    private func date() -> some View {
        Text(viewModel.date)
            .modifier(
                TextViewModifier(style: DefaultTheme().primaryTextStyle())
            )
            .padding([.horizontal], 16)
    }

    @ViewBuilder
    private func currency() -> some View {
        Text(viewModel.selectedCurrency)
            .modifier(
                TextViewModifier(style: DefaultTheme().primaryTextStyle())
            )
            .padding([.horizontal], 16)
    }
}
