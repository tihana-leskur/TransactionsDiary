//
//  TransactionsListView.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 3/31/25.
//

import SwiftUI

struct TransactionsListView: View {
    @ObservedObject var viewModel: TransactionsListViewModel
    let coordinator: TransactionsListCoordinator
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer().frame(height: 5)
            transactionCells(viewModel.transactionsList)
            Spacer().frame(height: 20)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
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

    // TODO: tihana fix: remember scroll offset position; restore offset when reappears;
    // E.g. https://medium.com/dna-technology/saveable-scroll-position-in-swiftui-e57d3bebc7ad
    @ViewBuilder
    private func transactionCells(
        _ items: [ComponentItem]
    ) -> some View {
        ScrollView {
            LazyVStack {
                ForEach(Array(items.enumerated()), id: \.offset) { index, element in
                    OnlyTextComponentView(
                        item: .init(
                            id: element.id,
                            content: element.content,
                            textStyle: DefaultTheme()
                                .secondaryTextStyle(),
                            contentViewStyle: DefaultTheme()
                                .secondaryBackgroundStyle()
                        ),
                        height: 50,
                        width: nil,
                        textAlignement: .leading,
                        textPadding: 10,
                        contentViewPadding: 10
                    )
                    .frame(height: 50)
                    .onAppear {
                        viewModel.transactionAppearedAt(
                            index: index
                        )
                    }
                    .onTapGesture {
                        coordinator.showTransactionDetails(id: element.id)
                    }
                }
            }
        }
        .padding([.leading, .trailing], 16)
        .background(Color.white)
    }
}
