//
//  UrlSessionHttpClient.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 3/31/25.
//

import Combine
import Foundation

final class UrlSessionHttpClient: HttpClient {

    func execute(request: URLRequest) -> Future<Data, Error> {
        Future<Data, Error> { promise in
            promise(.success(Data()))
        }
    }
}
