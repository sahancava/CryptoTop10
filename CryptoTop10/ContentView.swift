import SwiftUI

struct Config: Decodable {
    let apiUrl: String
}

class AppConfig {
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

struct BlueButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal, 20)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct ContentView: View {
    @State private var cryptoViewModels: [CryptoViewModel] = []
    @State private var showError: Bool = false
    @State private var isLoading: Bool = false
    @State private var showSecondPage: Bool = false
    @State private var selectedPage: Int? = nil
    @StateObject private var secondPageViewModel = SecondPageViewModel()
    @State private var navigateToSecondPage = false
    @State private var shouldNavigate = false


    var body: some View {
        if showError {
            Image(systemName: "exclamationmark.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.red)
                .padding()
        } else {
            NavigationView {
                ZStack {
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
                                    VStack {
                                        Text(".")
                                            .bold()
                                            .foregroundColor(.red)
                                            .font(.system(size: 40)) // Adjust the font size as needed
                                            .padding(.top, 7.5)
                                        Spacer()
                                    }
                                    VStack(alignment: .leading) {
                                        Text(cryptoViewModel.crypto.name)
                                            .bold()
                                            .foregroundColor(.indigo)
                                        Text("$\(cryptoViewModel.crypto.current_price)")
                                            .foregroundColor(.black)
                                    }
                                    Spacer()
                                }
                                .background(Color.white)
                            }
                        }

                        // Next Page Button
                        Section {
                            NavigationLink(
                                destination: SecondPageView(),
                                label: {
                                    Text("Next Page")
                                        .font(.title)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                            )
                            .buttonStyle(PlainButtonStyle())  // removes the default button background in List
                            .listRowInsets(EdgeInsets())  // removes the default padding
                            .listRowBackground(Color.clear)  // ensures no white background
                        }
                    }
                    .onAppear(perform: loadData)
                    
                    if isLoading {
                        Color.white.opacity(0.5) // Semi-transparent background
                            .edgesIgnoringSafeArea(.all)
                            .disabled(true) // Disable interaction
                        customProgressView
                    }
                }
                .navigationBarHidden(true)
            }

            .onReceive(timer) { _ in
                // Set isLoading to true and load data
                if !isLoading {
                    isLoading = true
                    loadData()
                }
            }
        }
    }
    
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    var customProgressView: some View {
        ProgressView()
            .scaleEffect(3.0) // Make the spinner three times its size
    }
    
    func loadData() {
        isLoading = true
        let apiUrl = AppConfig.shared.apiUrl

        
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                isLoading = false
            }
        }.resume()
    }

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
