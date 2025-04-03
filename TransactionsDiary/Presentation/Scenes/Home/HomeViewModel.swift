//
//  HomeViewModel.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 3/31/25.
//

import Combine
import SwiftUI

final class HomeViewModel: ObservableObject {
    @Published var state: HomeItem = HomeViewModel.createStaticState()
    @Published var currentMonthTransactions: [ComponentItem] = []

    private let transactionService: TransactionService
    private var cancellables: Set<AnyCancellable> = .init()

    struct HomeItem {
        let title: ComponentItem
        let currentMonthHeader: ComponentItem
        let addInvoice: ComponentItem
        let addReceipt: ComponentItem
        let seeAllTransactions: ComponentItem

        static let empty = HomeItem(
            title: .empty,
            currentMonthHeader: .empty,
            addInvoice: .empty,
            addReceipt: .empty,
            seeAllTransactions: .empty
        )
    }

    init(transactionService: TransactionService) {
        self.transactionService = transactionService
    }

    func viewWillAppear() {
        updateCurrentMonthTransactions()
    }
}

// MARK: - State Utils
private extension HomeViewModel {

    // TODO: tihana localize me; remove onTap from ComponentItem
    static func createStaticState() -> HomeItem {
        HomeItem(
            title:  ComponentItem(
                id: UUID(),
                content: "Hello John",
                onTap: {}
            ),
            currentMonthHeader:  ComponentItem(
                id: UUID(),
                content: "Current Month",
                onTap: {}
            ),
            addInvoice: ComponentItem(
                id: UUID(),
                content: "Add Invoice",
                onTap: {}
            ),
            addReceipt: ComponentItem(
                id: UUID(),
                content: "Add receipt",
                onTap: {}
            ),
            seeAllTransactions: ComponentItem(
                id: UUID(),
                content: "See All Transactions",
                onTap: {}
            )
        )
    }

    func updateCurrentMonthTransactions() {
        transactionService.getLastTransactions(count: 3) // TODO: tihana put me in Constants availbale in test
            .receive(on: DispatchQueue.main)
            .sink { result in
                if case .failure = result {
                    print("ERROr HomeViewModel - could not load transactions data")
                }
            } receiveValue: { [weak self] transactions in
                self?.currentMonthTransactions = transactions.map {
                    ComponentItem(
                        id: $0.id,
                        content: $0.type.rawValue + " " + String($0.amount),
                        onTap: {}
                    )
                }
            }
            .store(in: &cancellables)

    }
}
