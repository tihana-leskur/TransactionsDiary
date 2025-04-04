//
//  TransactionsListViewModel.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 3/31/25.
//

import Combine
import SwiftUI

final class TransactionsListViewModel: ObservableObject {
    @Published var transactionsList: [ComponentItem] = []
    @Published var isLoading = false
    let title = "Transactions" // TODO: tihana localize me
    
    private let transactionService: TransactionService
    private let batchSize: Int
    private let loadingThreshold: Int
    private var loadBatchRequestsSubject: PassthroughSubject<Int, Never> = .init()
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(
        transactionsService: TransactionService,
        batchSize: Int = 10, // TODO: tihana from config
        loadingThreshold: Int = 5 // TODO: tihana from config
    ) {
        self.transactionService = transactionsService
        self.batchSize = batchSize
        self.loadingThreshold = loadingThreshold
        subscribeToLoadBatchRequests()
    }

    func viewWillAppear() {
        loadBatchRequestsSubject.send(0)
    }

    func transactionAppearedAt(index: Int) {
        loadBatchRequestsSubject.send(index)
    }
}

// MARK: - State Utils
private extension TransactionsListViewModel {
    func subscribeToLoadBatchRequests() {
        loadBatchRequestsSubject
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .sink { [weak self] index in
                guard let self = self else {
                    return
                }
                let shouldLoadInitialBatch = index == 0 && transactionsList.isEmpty
                let nextBatchIndex = (index / batchSize + 1) * batchSize
                // index satisfies threshold and batch is not already loaded (user scrolling up)
                let shouldLoadNextBatch = index % batchSize == loadingThreshold
                && nextBatchIndex >= transactionsList.count
                guard !self.isLoading,
                      shouldLoadInitialBatch || shouldLoadNextBatch else {
                    return
                }
                isLoading = true
                let fromIndex = index == 0 ? 0 : nextBatchIndex
                loadNextBatch(from: fromIndex)
            }
            .store(in: &cancellables)
    }
    
    func loadNextBatch(from index: Int) {
        transactionService.getTransactions(
            from: index,
            batchSize: batchSize
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] result in
            if case .failure = result {
                print("ERROR TransactionListViewModel - could not load transactions data")
                if index == 0 {
                    self?.createEmptyPageState()
                } else {
                    self?.createBatchErrorState()
                }
            }
        } receiveValue: { [weak self] transactions in
            self?.createBatchSuccessState(newBatch: transactions)
        }
        .store(in: &cancellables)
    }
    
    func createBatchSuccessState(newBatch: [Transaction]) {
        transactionsList = transactionsList + newBatch.map {
            ComponentItem(
                id: $0.id,
                content: $0.type.rawValue + " - " + formatDate(seconds: $0.timestamp),
                onTap: {}
            )
        }
        isLoading = false
    }
    
    func createEmptyPageState() {
        print("ERROR TransactionsListViewModel - could not get next batch; Here would be some Sorry, Try Again View")
        isLoading = false
    }
    
    func createBatchErrorState() {
        print("ERROR TransactionsListViewModel - could not get next batch; Here would be some Sorry, Try Again View")
        isLoading = false
    }
}
