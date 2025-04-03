//
//  TransactionPreviewViewModel.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 4/3/25.
//

import Combine
import SwiftUI

final class TransactionPreviewViewModel: ObservableObject {
    @Published var image: UIImage = UIImage()
    @Published var date: String = ""
    @Published var amount: String = ""
    @Published var selectedCurrency: String = ""
    
    private let transactionId: UUID
    private let transactionService: TransactionService
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(
        transactionId: UUID,
        transactionService: TransactionService
    ) {
        self.transactionId = transactionId
        self.transactionService = transactionService
    }
    
    func viewWillAppear() {
        loadTransactionData(id: transactionId)
    }

    private func loadTransactionData(id: UUID) {
        transactionService.getTransactionDetails(id: id)
            .receive(on: DispatchQueue.main)
            .sink { result in
                if case .failure = result {
                    print("ERROr TransactionPreviewViewModel - could not load transactions data")
                }
            } receiveValue: { [weak self] details in
                self?.image = UIImage(data: details.imageData) ?? UIImage()
                self?.date = formatDate(seconds: details.timestamp)
                self?.amount = String(details.amount)
                self?.selectedCurrency = details.currency.rawValue
            }
            .store(in: &cancellables)
    }
}
