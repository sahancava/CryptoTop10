//
//  CryptoAPI.swift
//  CryptoTop10
//
//  Created by sahanc on 12.08.2023.
//

import Foundation

class CryptoAPI {
    func fetchData(from url: URL, completion: @escaping (Result<[Crypto], Error>) -> Void) {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 5
        config.timeoutIntervalForResource = 5
        let session = URLSession(configuration: config)
        
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode([Crypto].self, from: data)
                    let top15 = Array(decodedData.prefix(15))
                    completion(.success(top15))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
