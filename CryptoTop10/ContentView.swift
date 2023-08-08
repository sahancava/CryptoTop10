//
//  ContentView.swift
//  CryptoTop10
//
//  Created by sahanc on 8.08.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var cryptoViewModels: [CryptoViewModel] = []
    @State private var showError: Bool = false

    var body: some View {
        if showError {
            Image(systemName: "exclamationmark.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.red)
                .padding()
        } else {
            List {
                // SUBSCRIBE Section
                Section(header:
                    HStack {
                        Spacer()
                        Text("SUBSCRIBE")
                            .bold()
                            .font(.largeTitle)
                            .foregroundColor(.red)
                        Spacer()
                    }
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .padding(.top, 10) // Adds a top margin
                    .onTapGesture {
                    // Implement the subscription action here.
                        print("Subscribe tapped!")
                    }
                ) {
                    EmptyView() // This ensures the section only contains the header
                }
                
                // Cryptocurrencies Section
                Section {
                    ForEach(cryptoViewModels, id: \.crypto.id) { cryptoViewModel in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(cryptoViewModel.crypto.name)
                                Text("\(cryptoViewModel.crypto.market_cap)")
                            }
                            Spacer()
                        }
                        .background(Color.white)
                    }
                }
            }
            .onAppear(perform: loadData)
        }
    }

    func loadData() {
        let apiUrl = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_volume_desc&limit=15&lang=en&sparkline=false&price_change_percentage=false&market_data=true&market_cap_change_percentage_24h=false&volume_change_24h=false&market_cap_change_24h=false&price_change_percentage_24h_in_currency=false&market_cap_change_percentage_24h_in_currency=false&sparkline_in_7d=false&price_change_percentage_7d_in_currency=false&exchange_ids=false&exchange_volume_24h=false&market_cap_change_24h_in_currency=false&price_change_percentage_1h_in_currency=false&price_change_percentage_7d_in_currency=false&price_change_percentage_30d_in_currency=false&price_change_percentage_14d_in_currency=false&market_cap_change_percentage_7d_in_currency=false&market_cap_change_percentage_14d_in_currency=false&market_cap_change_percentage_30d_in_currency=false&exchange_volume_24h_in_currency=false&market_cap_change_1h_in_currency=false&market_cap_change_7d_in_currency=false&market_cap_change_14d_in_currency=false&market_cap_change_30d_in_currency=false&percent_change_1h_in_currency=false&percent_change_24h_in_currency=false&percent_change_7d_in_currency=false&percent_change_14d_in_currency=false&percent_change_30d_in_currency=false&percent_change_60d_in_currency=false&percent_change_90d_in_currency=false&percent_change_180d_in_currency=false&percent_change_365d_in_currency=false&order=market_cap_desc&order=market_volume_desc&order=market_cap_change_pct_24h_desc&order=market_dominance_desc&order=percent_change_24h_desc"

        
        guard let url = URL(string: apiUrl) else { return }
        
        // Set up a URLSession with a timeout
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 5
        config.timeoutIntervalForResource = 5
        let session = URLSession(configuration: config)
        
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                DispatchQueue.main.async {
                    self.showError = true
                }
                return
            }
            
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode([Crypto].self, from: data)
                    let top15 = Array(decodedData.prefix(15))
                    DispatchQueue.main.async {
                        self.cryptoViewModels = top15.map { CryptoViewModel(crypto: $0) }
                    }
                } catch {
                    print("Decoding error: \(error)")
                    DispatchQueue.main.async {
                        self.showError = true
                    }
                }
            }
        }.resume()
    }

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
