//
//  CryptoTop10App.swift
//  CryptoTop10
//
//  Created by sahanc on 8.08.2023.
//

import SwiftUI
import Foundation

@main
struct CryptoTop10App: App {
    var body: some Scene {
        WindowGroup {
            //ContentView()
                //.environmentObject(AppConfig.shared)
            PDFUploadContentView()
        }
    }
}
