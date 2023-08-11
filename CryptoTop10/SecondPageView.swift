import SwiftUI

class SecondPageViewModel: ObservableObject {
    @Published var showSecondPage = false
}

struct SecondPageView: View {
    @ObservedObject private var secondPageViewModel = SecondPageViewModel()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .foregroundColor(.green)
                .frame(width: 100, height: 100)
            Text("Welcome to the second page")
                .font(.title)
                .foregroundColor(.green)
                .padding(.top, 20)
            Spacer()
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Previous Page")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.bottom, 20)
        }
    }
}
