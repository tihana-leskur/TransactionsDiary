//
//  Transaction.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 3/30/25.
//

import Foundation

struct Transaction: DomainEntity {
    let id: UUID
    let name: String
    let timestamp: Double
    let amount: Double
    let currency: Currency
    let type: TransactionType
}
