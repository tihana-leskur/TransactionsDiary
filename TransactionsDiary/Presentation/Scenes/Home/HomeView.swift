//
//  HomeView.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 3/31/25.
//

import SwiftUI

// TODO: tihana theme as env object
struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    let coordinator: HomeCoordinator

    var body: some View {
        ScrollView {
            Spacer().frame(height: 60)
            VStack(alignment: .leading) {
                title()
                Spacer().frame(height: 10)
                currentMonthHeader()
                Spacer().frame(height: 10)
                transactionCells(
                    viewModel.currentMonthTransactions
                )
                Spacer().frame(height: 30)
                buttons()
                Spacer()
            }
        }
        .addBackgroundView(hasNavigationBar: false)
        .onWillAppear {
            viewModel.viewWillAppear()
            coordinator.syncNavigationBarVisibility()
        }
    }
    
    @ViewBuilder
    private func title() -> some View {
        OnlyTextComponentView(
            item: .init(
                id: viewModel.state.title.id,
                content: viewModel.state.title.content,
                textStyle: DefaultTheme().titleTextStyle(),
                onTap: viewModel.state.title.onTap
            ),
            height: 75,
            width: nil,
            textAlignement: .leading,
            textPadding: 3,
            contentViewPadding: 16
        )
    }
    
    @ViewBuilder
    private func currentMonthHeader() -> some View {
        OnlyTextComponentView(
            item: .init(
                id: viewModel.state.currentMonthHeader.id,
                content: viewModel.state.currentMonthHeader.content,
                textStyle: DefaultTheme().headerTextStyle(),
                onTap: {}
            ),
            height: 40,
            width: nil,
            textAlignement: .leading,
            textPadding: 3,
            contentViewPadding: 16
        )
    }
    
    @ViewBuilder
    private func transactionCells(
        _ items: [ComponentItem]
    ) -> some View {
        LazyVGrid(columns: [
            GridItem(.fixed(150), spacing: 20),
            GridItem(.fixed(150), spacing: 20)
        ], spacing: 10
        ) {
            ForEach(items) {
                OnlyTextComponentView(
                    item: .init(
                        id: $0.id,
                        content: $0.content,
                        textStyle: DefaultTheme()
                            .primaryTextStyle(),
                        contentViewStyle: DefaultTheme()
                            .secondaryBackgroundStyle(),
                        onTap: {}
                    ),
                    height: 80,
                    width: nil,
                    textAlignement: .leading,
                    textPadding: 10,
                    contentViewPadding: 0
                )
                .frame(height: 80)
            }
        }
    }

    @ViewBuilder
    private func buttons() -> some View {
        VStack(alignment: .center) {
            addInvoiceButton()
            Spacer().frame(height: 20)
            addReceiptButton()
            Spacer().frame(height: 20)
            seeAlltransactionsButton()
        }
        .padding([.leading, .trailing], 16)
    }
    
    @ViewBuilder
    private func addInvoiceButton() -> some View {
        OnlyTextComponentView(
            item: .init(
                id: viewModel.state.addInvoice.id,
                content: viewModel.state.addInvoice.content,
                textStyle: DefaultTheme()
                    .enabledButtonTextStyle(), // if state can be changed it would be another Published in VM
                contentViewStyle: DefaultTheme()
                    .enabledButtonBackgroundStyle(),
                onTap: {}
            ),
            height: 50,
            width: nil,
            textAlignement: .center,
            textPadding: 3,
            contentViewPadding: 0
        )
        .onTapGesture {
            coordinator.startAddTransaction(.invoice)
        }
        .frame(height: 50)
    }
    
    @ViewBuilder
    private func addReceiptButton() -> some View {
        OnlyTextComponentView(
            item: .init(
                id: viewModel.state.addReceipt.id,
                content: viewModel.state.addReceipt.content,
                textStyle: DefaultTheme()
                    .enabledButtonTextStyle(),
                contentViewStyle: DefaultTheme()
                    .enabledButtonBackgroundStyle(),
                onTap: {}
            ),
            height: 50,
            width: nil,
            textAlignement: .center,
            textPadding: 3,
            contentViewPadding: 0
        )
        .onTapGesture {
            coordinator.startAddTransaction(.receipt)
        }
        .frame(height: 50)
    }
    
    @ViewBuilder
    private func seeAlltransactionsButton() -> some View {
        OnlyTextComponentView(
            item: .init(
                id: viewModel.state.seeAllTransactions.id,
                content: viewModel.state.seeAllTransactions.content,
                textStyle: DefaultTheme()
                    .enabledButtonTextStyle(), // if state can be changed it would be another Published in VM
                contentViewStyle: DefaultTheme()
                    .enabledButtonBackgroundStyle(),
                onTap: {}
            ),
            height: 50,
            width: nil,
            textAlignement: .center,
            textPadding: 3,
            contentViewPadding: 0
        )
        .onTapGesture {
            coordinator.showAllTransactions()
        }
        .frame(height: 50)
    }
}
