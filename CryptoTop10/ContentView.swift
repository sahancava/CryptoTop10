import SwiftUI

struct Config: Decodable {
    let apiUrl: String
}

struct ContentView: View {
    @State private var cryptoViewModels: [CryptoViewModel] = []
    @State private var errorMessage: String? = nil
    @State private var isLoading: Bool = false
    @EnvironmentObject var appConfig: AppConfig

    private var api = CryptoAPI()
    
    var body: some View {
        NavigationView {
            ZStack {
                // Check for errors
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    // Crypto list
                    List(cryptoViewModels, id: \.crypto.id) { cryptoViewModel in
                        CryptoRow(viewModel: cryptoViewModel)
                    }
                    .onAppear(perform: loadData)
                    .blur(radius: isLoading ? 3.0 : 0)
                    
                    // Loading indicator
                    if isLoading {
                        LoadingView()
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .onReceive(timer) { _ in
            if !isLoading {
                loadData()
            }
        }
    }
    
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    func loadData() {
        isLoading = true
        guard let url = URL(string: appConfig.apiUrl) else { return }

        api.fetchData(from: url) { result in
            switch result {
            case .success(let cryptos):
                cryptoViewModels = cryptos.map { CryptoViewModel(crypto: $0) }
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}

struct CryptoRow: View {
    var viewModel: CryptoViewModel
    
    var body: some View {
        HStack {
            VStack {
                Text(".")
                    .bold()
                    .foregroundColor(.red)
                    .font(.system(size: 40))
                    .padding(.top, 7.5)
                Spacer()
            }
            VStack(alignment: .leading) {
                Text(viewModel.crypto.name)
                    .bold()
                    .foregroundColor(.indigo)
                Text("$\(viewModel.crypto.current_price)")
                    .foregroundColor(.black)
            }
            Spacer()
        }
        .background(Color.white)
    }
}

struct LoadingView: View {
    var body: some View {
        Color.white.opacity(0.5)
            .edgesIgnoringSafeArea(.all)
            .disabled(true)
        ProgressView()
            .scaleEffect(3.0)
    }
}
