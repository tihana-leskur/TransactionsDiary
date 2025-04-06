//
//  TransactionRepository.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 4/1/25.
//

import Combine
import Foundation

// TODO: tihana map to specific error types on each layer
enum TransactionRepositoryError: Error {
    case requestFailed
}

protocol TransactionRepository {
    init(databaseSource: DatabaseDataSource) // cacheLifeDuration
    func createTransaction(
        _ transaction: TransactionDetails,
        for userId: UUID
    ) -> Future<Void, Error>
    func createTransactions(
        _ transaction: [TransactionDetails],
        for userId: UUID
    ) -> Future<Void, Error>
    func getTransactions(
        userId: UUID,
        parameters: RepositoryQueryParameters?
    ) -> Future<[Transaction], Error>
    func getTransactionDetails(id: UUID) -> Future<TransactionDetails, Error>
    // update, delete
}

final class DefaultTransactionRepository: TransactionRepository {
    private let databaseSource: DatabaseDataSource
    private var cancellables: Set<AnyCancellable> = .init()
    let defaultSortDescriptors: [NSSortDescriptor] = [
        NSSortDescriptor(key: #keyPath(TransactionEntity.timestamp), ascending: false)
    ]

    init(databaseSource: DatabaseDataSource) {
        self.databaseSource = databaseSource
    }

    func createTransaction(
        _ transaction: TransactionDetails,
        for userId: UUID
    ) -> Future<Void, Error> {
        databaseSource.create(
            parent: TransactionEntity.self,
            child: ImageEntity.self,
            parentModel: TransactionModel(
                id: transaction.id,
                userId: userId,
                name: transaction.name,
                timestamp: transaction.timestamp,
                amount: transaction.amount,
                currency: transaction.currency.rawValue,
                type: transaction.type.rawValue
            ),
            childModel: ImageModel(
                id: transaction.imageId,
                data: transaction.imageData
            ),
            relationName: .image
        )
    }

    func createTransactions(
        _ transactions: [TransactionDetails],
        for userId: UUID
    ) -> Future<Void, Error> {
        let parentModels = transactions.map {
            TransactionModel(
                id: $0.id,
                userId: userId,
                name: $0.name,
                timestamp: $0.timestamp,
                amount: $0.amount,
                currency: $0.currency.rawValue,
                type: $0.type.rawValue
            )
        }
        
        let childModels = transactions.map {
            ImageModel(
                id: $0.id,
                data: $0.imageData
            )
        }

        return databaseSource.createMultiple(
            parent: TransactionEntity.self,
            child: ImageEntity.self,
            parentModels: parentModels,
            childModels: childModels,
            relationName: .image
        )
    }

    func getTransactions(
        userId: UUID,
        parameters: RepositoryQueryParameters?
    ) -> Future<[Transaction], Error> {
        // check if cached transactions already contains transactions with desired parameters
        // don't call db if exists in cache
        // prepare for "greedy" users; fetch a bit more than required
        // (another batch or two, based on usage analysis)
        Future<[Transaction], Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(DatabaseError.deallocated))
                return
            }

            let sortDescriptors = parameters?.sortParameters.map { [weak self] in
                self?.createSortDescriptors(from: $0) ?? []
            } ?? defaultSortDescriptors

            let query = DatabaseQueryParemeters(
                predicate: NSPredicate(format: "userId = %@", userId.uuidString),
                sortDescriptors: sortDescriptors,
                fetchOffset: fetchOffset(
                    for: parameters?.fetchLimit,
                    desiredOffset: parameters?.fetchOffset
                ),
                fetchLimit: parameters?.fetchLimit
            )

            databaseSource.get(
                TransactionEntity.self,
                query: query
            ).sink { result in
                if case .failure = result {
                    print("ERROR TransactionRepository - could not load transactions data")
                    promise(.failure(DatabaseError.fetchFailed))
                }
            } receiveValue: { dataModels in
                let domainModels = dataModels.map {
                    Transaction(
                        id: $0.id,
                        name: $0.name,
                        timestamp: $0.timestamp,
                        amount: $0.amount,
                        currency: Currency(rawValue: $0.currency) ?? .eur,
                        type: TransactionType(rawValue: $0.type) ?? .invoice
                    )
                }
                promise(.success(domainModels))
            }
            .store(in: &cancellables)
        }
    }

    func getTransactionDetails(id: UUID) -> Future<TransactionDetails, Error> {
        Future<TransactionDetails, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(DatabaseError.deallocated))
                return
            }
            let transactionQuery = DatabaseQueryParemeters(
                predicate: NSPredicate(format: "id = %@", id.uuidString),
                fetchLimit: 1
            )
            let transactionRequest = databaseSource.get(
                TransactionEntity.self,
                query: transactionQuery
            )
            let imageQuery = DatabaseQueryParemeters(
                predicate: NSPredicate(format: "transaction.id = %@", id.uuidString)
            )
            let imageRequest =  databaseSource.get(
                ImageEntity.self,
                query: imageQuery
            )
            Publishers.Zip(transactionRequest, imageRequest)
                .sink { result in
                    if case .failure = result {
                        print("ERROR TransactionRepository - could not load transactions details")
                        promise(.failure(DatabaseError.fetchFailed))
                    }
                } receiveValue: { (transactionModels, imageModels) in
                    guard let transaction = transactionModels.first,
                          let image = imageModels.first else {
                        promise(.failure(DatabaseError.invalidEntityType))
                        return
                    }
                    let transactionDetails = TransactionDetails(
                        id: transaction.id,
                        name: transaction.name,
                        timestamp: transaction.timestamp,
                        amount: transaction.amount,
                        currency: .init(rawValue: transaction.currency) ?? .eur,
                        type: .init(rawValue: transaction.type) ?? .invoice,
                        imageId: image.id,
                        imageData: image.data
                    )
                    promise(.success(transactionDetails))
                }
                .store(in: &cancellables)
        }
    }
}

private extension DefaultTransactionRepository {
    func createSortDescriptors(from parameters: SortParameters) -> [NSSortDescriptor] {
        var key: String = ""
        switch parameters.field {
            case .date:
                key = #keyPath(TransactionEntity.timestamp)
            case .amount:
                key = #keyPath(TransactionEntity.amount)
        }
        let sortDescriptor = NSSortDescriptor(
            key: key,
            ascending: parameters.direction == .ascending
        )
        return [sortDescriptor]
    }

    func fetchOffset(for fetchLimit: Int?, desiredOffset: Int?) -> Int? {
        if desiredOffset == nil && fetchLimit != nil {
            return 0
        } else {
            return desiredOffset
        }
    }
}
