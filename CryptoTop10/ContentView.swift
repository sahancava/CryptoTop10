//
//  ContentView.swift
//  CryptoTop10
//
//  Created by sahanc on 8.08.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var cryptoViewModels: [CryptoViewModel] = []
    @State private var showAlert = false
    @State private var listRefresh: Bool = false

    var favoriteCryptos: [CryptoViewModel] {
        return cryptoViewModels.filter { $0.isFavorite }
    }
    var body: some View {
        VStack {
            if !favoriteCryptos.isEmpty {
                Text("Favorites")
                    .font(.headline)
                List(favoriteCryptos, id: \.crypto.id) { cryptoViewModel in
                    Text(cryptoViewModel.crypto.name)
                }
                .id(listRefresh)
            }

            List(cryptoViewModels, id: \.crypto.id) { cryptoViewModel in
                HStack {
                    VStack(alignment: .leading) {
                        Text(cryptoViewModel.crypto.name)
                        Text("\(cryptoViewModel.crypto.market_cap)")
                    }
                    Spacer()
                    Button(action: {
                        print("Star button was tapped!")
                        toggleFavorite(cryptoViewModel: cryptoViewModel)
                    }) {
                        Image(systemName: cryptoViewModel.isFavorite ? "star.fill" : "star")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(cryptoViewModel.isFavorite ? .yellow : .gray)
                    }
                    .padding(10)
                }
            }
        }
        .onAppear(perform: loadData)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text("You cannot add more than 5 cryptocurrencies to your list"), dismissButton: .default(Text("OK")))
        }
    }
    
    func toggleFavorite(cryptoViewModel: CryptoViewModel) {
        if !cryptoViewModel.isFavorite && favoriteCryptos.count >= 5 {
            showAlert = true
        } else {
            cryptoViewModel.isFavorite.toggle()
            listRefresh.toggle()
        }
    }

    func loadData() {
        let apiUrl = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_volume_desc&limit=10&lang=en&sparkline=false&price_change_percentage=false&market_data=true&market_cap_change_percentage_24h=false&volume_change_24h=false&market_cap_change_24h=false&price_change_percentage_24h_in_currency=false&market_cap_change_percentage_24h_in_currency=false&sparkline_in_7d=false&price_change_percentage_7d_in_currency=false&exchange_ids=false&exchange_volume_24h=false&market_cap_change_24h_in_currency=false&price_change_percentage_1h_in_currency=false&price_change_percentage_7d_in_currency=false&price_change_percentage_30d_in_currency=false&price_change_percentage_14d_in_currency=false&market_cap_change_percentage_7d_in_currency=false&market_cap_change_percentage_14d_in_currency=false&market_cap_change_percentage_30d_in_currency=false&exchange_volume_24h_in_currency=false&market_cap_change_1h_in_currency=false&market_cap_change_7d_in_currency=false&market_cap_change_14d_in_currency=false&market_cap_change_30d_in_currency=false&percent_change_1h_in_currency=false&percent_change_24h_in_currency=false&percent_change_7d_in_currency=false&percent_change_14d_in_currency=false&percent_change_30d_in_currency=false&percent_change_60d_in_currency=false&percent_change_90d_in_currency=false&percent_change_180d_in_currency=false&percent_change_365d_in_currency=false&order=market_cap_desc&order=market_volume_desc&order=market_cap_change_pct_24h_desc&order=market_dominance_desc&order=percent_change_24h_desc"

        guard let url = URL(string: apiUrl) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let decodedData = try? JSONDecoder().decode([Crypto].self, from: data) {
                    DispatchQueue.main.async {
                        self.cryptoViewModels = decodedData.map { CryptoViewModel(crypto: $0) }
                    }
                }
            }
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
