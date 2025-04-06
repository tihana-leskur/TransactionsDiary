//
//  CoreDataTest.swift
//  TransactionsDiaryTests
//
//  Created by tihana leskur on 4/6/25.
//

import XCTest
@testable import TransactionsDiary

class CoreDataTest: XCTestCase {
    
    func createTransaction(
        id: UUID = UUID(),
        userId: UUID = UUID()
    ) -> TransactionModel {
        TransactionModel(
            id: id,
            userId: userId,
            name: "test1",
            timestamp: 10,
            amount: 555,
            currency: Currency.eur.rawValue,
            type: TransactionType.invoice.rawValue
        )
    }
    
    func createImage(id: UUID = UUID()) -> ImageModel {
        ImageModel(id: id, data: Data())
    }
}
