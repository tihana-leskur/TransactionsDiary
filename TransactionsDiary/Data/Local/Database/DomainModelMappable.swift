//
//  DomainModel.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 4/1/25.
//

import Foundation

// TODO: tihana rename
protocol DomainModel: Equatable {}

protocol DomainModelMappable {
    associatedtype DomainModel
    func fromDomainModel(_ model: DomainModel)
    func toDomainModel() -> DomainModel
}

struct TransactionModel: DomainModel {
    let id: UUID
    let userId: UUID
    let name: String
    let timestamp: Double
    let amount: Double
    let currency: String
    let type: String
}

struct ImageModel: DomainModel {
    let id: UUID
    let data: Data
}
