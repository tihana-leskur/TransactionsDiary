//
//  RepositoryQueryParameters.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 4/3/25.
//

import Foundation

// MARK: - SortDirection
enum SortDirection {
    case ascending
    case descending
}

// MARK: - SortField
enum SortField {
    case date
    case amount
}

// MARK: - SortParameters
struct SortParameters {
    let direction: SortDirection
    let field: SortField
}

// MARK: - RepositoryQueryParameters
struct RepositoryQueryParameters {
    let sortParameters: SortParameters?
    let fetchOffset: Int?
    let fetchLimit: Int?

    init(
        sortParameters: SortParameters? = nil,
        fetchOffset: Int? = nil,
        fetchLimit: Int? = nil
    ) {
        self.sortParameters = sortParameters
        self.fetchOffset = fetchOffset
        self.fetchLimit = fetchLimit
    }

    static let empty = RepositoryQueryParameters()
}
