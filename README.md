# CryptoTop10

CryptoTop10 is a SwiftUI iOS app that displays information about the top 15 cryptocurrencies. It fetches data from a remote API and presents it in a list format, allowing users to stay updated on cryptocurrency market data.

## Features

- Displays the top 15 cryptocurrencies based on market capitalization.
- Provides a "SUBSCRIBE" section, which can be tapped to perform a subscription action.
- Automatically reloads data every 60 seconds to keep the information up to date.
- Shows a spinner while loading data and disables interaction during data loading.

## How to Run

1. Clone this repository to your local machine.

git clone https://github.com/sahancava/CryptoTop10

2. Open the Xcode project `CryptoTop10.xcodeproj` using Xcode.

3. Build and run the app on a simulator or a physical iOS device.

4. The app will fetch cryptocurrency data from a remote API every 60 seconds and display it in a list. Tap the "SUBSCRIBE" header to perform a subscription action.

## Configuration

The API URL used by the app is specified in the `Config.json` file. Make sure to provide a valid API URL in this file before running the app.

## Requirements

- Xcode 12.0 or later
- iOS 14.0 or later

## Credits

- The app uses SwiftUI for its user interface.
- Data is fetched from a remote API using URLSession.
- UserNotifications is used to schedule notifications.
- ProgressView is customized to show a loading spinner.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

