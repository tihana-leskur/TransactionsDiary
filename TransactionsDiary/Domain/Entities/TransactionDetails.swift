//
//  TransactionDetails.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 4/1/25.
//

import Foundation

struct TransactionDetails {
    let id: UUID
    let name: String
    let timestamp: Double
    let amount: Double
    let currency: Currency
    let type: TransactionType
    let imageId: UUID
    let imageData: Data
}
