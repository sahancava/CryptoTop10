//
//  Crypto.swift
//  CryptoTop10
//
//  Created by sahanc on 8.08.2023.
//

import Foundation

struct Crypto: Identifiable, Decodable {
    let id: String
    let name: String
    let market_cap: Double
}

class CryptoViewModel: ObservableObject {
    @Published var crypto: Crypto
    
    init(crypto: Crypto) {
        self.crypto = crypto
    }
}
