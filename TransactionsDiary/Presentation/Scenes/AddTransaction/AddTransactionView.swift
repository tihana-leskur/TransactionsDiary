//
//  AddTransactionView.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 4/1/25.
//

import SwiftUI

// TODO: tihana fix: focused state text field; currency and date don't have to be changed
struct AddTransactionView: View {
    @ObservedObject var viewModel: AddTransactionViewModel
    @State private var isDatePickerVisible = false

    private let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var body: some View {
        VStack {
            Spacer().frame(height: 10)
            Image(uiImage: viewModel.image)
                .resizable()
                .frame(width: 300, height: 300)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .aspectRatio(contentMode: .fit)
                .onTapGesture {
                    endTextEditing()
                }
            Spacer().frame(height: 10)
            amountField()
            Spacer().frame(height: 10)
            datePicker()
            Spacer().frame(height: 10)
            currencyPicker()
            Spacer()
            actionButton()
                .frame(height: 50)
            Spacer().frame(height: 30)
        }
        .addBackgroundView()
        .modifier(
            NavigationBarViewModifier(
                title: viewModel.title,
                style: DefaultTheme().modalNavigationBarStyle(),
                onTap: { viewModel.onBackButtonTapped() }
            ))
    }

    @ViewBuilder
    private func amountField() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Enter amount")
                .modifier(
                    TextViewModifier(style: DefaultTheme().header2TextStyle())
                )
                .padding([.horizontal], 16)
            // TODO: tihana create TextFieldStyle
            TextField("", value: $viewModel.amount, formatter: decimalFormatter)
                .font(
                    .custom(
                        DefaultTheme().fontName,
                        size: DefaultTheme().headerFontSize
                    )
                )
                .foregroundColor(.black)
                .background(
                    RoundedRectangle(
                        cornerRadius: DefaultTheme().secondaryCornerRadius
                    )
                    .fill(
                        Color.white
                    )
                )
                .keyboardType(.numberPad)
                .padding()
        }
    }

    @ViewBuilder
    private func datePicker() -> some View {
        DatePicker(selection: $viewModel.date, in: ...Date.now, displayedComponents: [.date, .hourAndMinute]) {
            Text("Select a date")
                .modifier(
                    TextViewModifier(style: DefaultTheme().primaryTextStyle())
                )
            
        }
        .padding([.horizontal], 16)
    }

    @ViewBuilder
    private func currencyPicker() -> some View {
        Picker("Choose a currency", selection: $viewModel.selectedCurrency) {
            ForEach(Currency.allCases, id: \.self) {
                Text($0.rawValue)
            }
        }
    }

    @ViewBuilder
    private func actionButton() -> some View {
        OnlyTextComponentView(
            item: .init(
                content: viewModel.actionButtonState.content,
                textStyle: viewModel.actionButtonState.isEnabled ?
                DefaultTheme().enabledButtonTextStyle() : DefaultTheme().disabledButtonTextStyle(),
                contentViewStyle: viewModel.actionButtonState.isEnabled ?
                DefaultTheme().enabledButtonBackgroundStyle() : DefaultTheme().disabledButtonBackgroundStyle(),
                onTap: {}
            ),
            height: 100,
            width: nil,
            textAlignement: .center,
            textPadding: 20,
            contentViewPadding: 16
        )
        .onTapGesture {
            // TODO: tihana button item from vm with isEnabled
            if viewModel.actionButtonState.isEnabled {
                viewModel.actionButtonTapped()
            }
        }
    }
}


