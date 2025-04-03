//
//  TransactionEntity.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 3/30/25.
//

import Foundation
import CoreData

// TODO: tihana try to create interfaces for entities
// to enforce their creation if database type changes
// (e.g. force Realm to name them like that / repo not affected)

@objc(TransactionEntity)
class TransactionEntity: NSManagedObject, Identifiable, DomainModelMappable {}

extension TransactionEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransactionEntity> {
        return NSFetchRequest<TransactionEntity>(entityName: "TransactionEntity")
    }
    
    @NSManaged var id: UUID
    @NSManaged var userId: UUID
    @NSManaged var name: String
    @NSManaged var timestamp: Double
    @NSManaged var amount: Double
    @NSManaged var currency: String
    @NSManaged var type: String
}

extension TransactionEntity {
    func fromDomainModel(_ model: TransactionModel) {
        self.id = model.id
        self.userId = model.userId
        self.timestamp = model.timestamp
        self.amount = model.amount
        self.currency = model.currency
        self.type = model.type
        self.name = model.name
    }
    
    func toDomainModel() -> TransactionModel {
        TransactionModel(
            id: self.id,
            userId: self.userId,
            name: self.name,
            timestamp: self.timestamp,
            amount: self.amount,
            currency: self.currency,
            type: self.type
        )
    }
}
