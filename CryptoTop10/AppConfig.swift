//
//  AppConfig.swift
//  CryptoTop10
//
//  Created by sahanc on 12.08.2023.
//

import Foundation

class AppConfig: ObservableObject {
    static var shared: AppConfig = {
        let configURL = Bundle.main.url(forResource: "Config", withExtension: "json")!
        let data = try! Data(contentsOf: configURL)
        let decoder = JSONDecoder()
        let config = try! decoder.decode(Config.self, from: data)
        return AppConfig(apiUrl: config.apiUrl)
    }()
    
    let apiUrl: String
    
    private init(apiUrl: String) {
        self.apiUrl = apiUrl
    }
}
