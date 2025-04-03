//
//  AddTransactionViewModel.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 4/1/25.
//

import Combine
import SwiftUI


final class AddTransactionViewModel: ObservableObject {
    private let transactionService: TransactionService
    private let coordinator: AddTransactionCoordinator
    private let type: TransactionType
    private let userInputSubject: PassthroughSubject<InputType, Never> = .init()
    private var cancellables: Set<AnyCancellable> = .init()
    private var validatedInputTypes: Set<InputType> = .init()
    
    @Published var isLoading = false
    // TODO: tihana doesn't have to be editted; fix me
    @Published var date: Date = Date() {
        didSet {
            userInputSubject.send(.date)
        }
    }
    @Published var amount: Double = 0 {
        didSet {
            userInputSubject.send(.amount)
        }
    }
    @Published var selectedCurrency: Currency = .dkk {
        didSet {
            userInputSubject.send(.currency)
        }
    }
    @Published var actionButtonState = ButtonItem(
        content: "Save",
        isEnabled: false
    )
    let image: UIImage
    let title: String
    
    private enum InputType: CaseIterable {
        case date
        case amount
        case currency
    }

    init(
        transactionService: TransactionService,
        coordinator: AddTransactionCoordinator,
        type: TransactionType,
        image: UIImage
    ) {
        self.transactionService = transactionService
        self.coordinator = coordinator
        self.type = type
        self.image = image
        self.title = "Add Transaction Details"
        subscribeToUserInput()
    }

    func onBackButtonTapped() {
        coordinator.dismiss()
    }

    func actionButtonTapped() {
        // TODO: tihana add loading state to view; wait for result
        isLoading = true
        transactionService.addTransaction(
            TransactionDetails(id: UUID(),
                               name: "newTransaction",
                               timestamp: date.timeIntervalSince1970,
                               amount: amount,
                               currency: selectedCurrency,
                               type: type,
                               imageId: UUID(),
                               imageData: image.pngData() ?? Data())
        )
        .receive(on: DispatchQueue.main)
        .sink { result in
            if case .failure = result {
                print("ERROR AddTransactionViewModel - could not load transactions data")
            }
        } receiveValue: { [weak self] _ in
            self?.isLoading = false
            self?.coordinator.dismiss()
        }
        .store(in: &cancellables)
    }
}

// MARK: - State Validation
private extension AddTransactionViewModel {
    func subscribeToUserInput() {
        userInputSubject
            .eraseToAnyPublisher()
            .sink { [weak self] inputType in
                guard let self = self else {
                   return
                }
                self.validatedInputTypes.insert(inputType)
                if self.validatedInputTypes.count == InputType.allCases.count {
                    actionButtonState = ButtonItem(
                        content: "Save",
                        isEnabled: true
                    )
                }
            }
            .store(in: &cancellables)
    }
}
