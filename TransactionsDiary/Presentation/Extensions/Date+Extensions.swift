//
//  Date+Extensions.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 4/3/25.
//

import Foundation

func formatDate(seconds: Double) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
    dateFormatter.locale = Locale(identifier: "fr_FR") // TODO: tihana read locale
    let date = dateFormatter.string(from: Date(timeIntervalSince1970: seconds))
    return date
}
