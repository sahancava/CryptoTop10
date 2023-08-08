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
    var isFavorite: Bool = false
}

class CryptoViewModel: Identifiable, ObservableObject {
    @Published var crypto: Crypto
    @Published var isFavorite: Bool
    
    init(crypto: Crypto) {
        self.crypto = crypto
        self.isFavorite = crypto.isFavorite
    }
}
