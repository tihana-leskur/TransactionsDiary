//
//  ImageEntity.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 3/30/25.
//

import Foundation
import CoreData

@objc(ImageEntity)
class ImageEntity: NSManagedObject, Identifiable, DomainModelMappable {}

extension ImageEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageEntity> {
        return NSFetchRequest<ImageEntity>(entityName: "ImageEntity")
    }

    @NSManaged var id: UUID
    @NSManaged var data: Data
}

extension ImageEntity {
    func fromDomainModel(_ model: ImageModel) {
        self.id = model.id
        self.data = model.data
    }
    
    func toDomainModel() -> ImageModel {
        ImageModel(id: self.id, data: self.data)
    }
}
