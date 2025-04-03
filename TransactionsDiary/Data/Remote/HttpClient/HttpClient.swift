//
//  HttpClient.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 3/31/25.
//

import Combine
import Foundation

protocol HttpClient {
    func execute(request: URLRequest) -> Future<Data, Error>
}
