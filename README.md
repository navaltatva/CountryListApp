Countries App
A SwiftUI application that allows users to search for countries and manage their favorite countries with detailed information including capitals and currencies.
Features
Core Features

✅ REST Countries API Integration: Fetches country data from https://restcountries.com/v2/all
✅ Country Search: Search countries by name or capital city
✅ Favorites Management: Add up to 5 countries to main view
✅ Detailed View: Display capital city and currency information
✅ Location-based Default: Automatically adds user's country based on GPS location
✅ Fallback Country: Defaults to India if location is denied or unavailable
✅ Remove Countries: Remove countries from favorites list

Additional Features

✅ Offline Storage: Save data locally using UserDefaults for offline usage
✅ Modern UI: Clean SwiftUI interface with contemporary design
✅ Error Handling: Comprehensive error handling for network and location services
✅ Unit Tests: Comprehensive test coverage for all components

Technical Requirements

iOS 15.0+
Swift 5+
SwiftUI Framework
Xcode 13.0+

Architecture
MVVM Pattern
The app follows the Model-View-ViewModel (MVVM) architectural pattern:

Models: Country, Currency
ViewModels: CountriesViewModel (Main business logic)
Views: SwiftUI views for different screens
Services: Network, Location, and Storage services

Key Components
Models
swiftstruct Country: Codable, Identifiable, Equatable {
    let name: String
    let capital: String?
    let alpha2Code: String
    let currencies: [Currency]?
}

struct Currency: Codable {
    let code: String?
    let name: String?
    let symbol: String?
}
Services

CountryService: Handles API calls and search functionality
LocationService: Manages GPS location and country detection
LocalStorageService: Handles offline data persistence

Main ViewModel
swiftclass CountriesViewModel: ObservableObject {
    @Published var allCountries: [Country] = []
    @Published var favoriteCountries: [Country] = []
    @Published var searchText = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedCountry: Country?
}
Project Structure
CountriesApp/
├── Models/
│   ├── Country.swift
│   └── Currency.swift
├── Services/
│   ├── CountryService.swift
│   ├── LocationService.swift
│   └── LocalStorageService.swift
├── ViewModels/
│   └── CountriesViewModel.swift
├── Views/
│   ├── ContentView.swift
│   ├── CountrySearchView.swift
│   ├── CountryDetailView.swift
│   └── Components/
│       ├── CountryCardView.swift
│       ├── CountryRowView.swift
│       └── SearchBar.swift
├── Tests/
│   ├── CountriesAppTests.swift
│   ├── ModelTests.swift
│   ├── ServiceTests.swift
│   └── ViewModelTests.swift
└── Resources/
    ├── Info.plist
    └── Assets.xcassets
Setup Instructions
1. Prerequisites

Xcode 13.0 or later
iOS 15.0+ deployment target
Active internet connection for API calls

2. Installation

Clone or download the project
Open CountriesApp.xcodeproj in Xcode
Build and run the project (⌘+R)

3. Configuration
The app is pre-configured with:

REST Countries API endpoint
Location permissions
Network security settings
Offline storage capabilities

4. Permissions
The app requires the following permissions:

Location Services: To detect user's country automatically
Network Access: To fetch country data from API

API Integration
REST Countries API

Endpoint: https://restcountries.com/v2/all
Method: GET
Response: Array of country objects with name, capital, currencies, and country codes

Sample API Response
json[
  {
    "name": "United States of America",
    "capital": "Washington, D.C.",
    "alpha2Code": "US",
    "currencies": [
      {
        "code": "USD",
        "name": "United States dollar",
        "symbol": "$"
      }
    ]
  }
]
Features Walkthrough
1. Main Screen

Displays up to 5 favorite countries in a grid layout
Shows country name, capital, and currency code
Remove button (X) to remove countries from favorites
Search button to add new countries

2. Search Screen

Search bar for filtering countries by name or capital
List of all available countries
Add button to add countries to favorites (disabled when limit reached)
"Done" button to close search

3. Detail Screen

Detailed view of selected country
Shows country name, capital, currency details, and country code
Modal presentation with "Done" button

4. Location Detection

Automatically detects user's location on app launch
Adds user's country to favorites if location permission granted
Falls back to India if location denied or detection fails

Testing
Unit Tests Coverage

✅ Model tests (Country, Currency)
✅ Service tests (CountryService, LocationService, LocalStorageService)
✅ ViewModel tests (CountriesViewModel)
✅ Integration tests
✅ Performance tests
✅ Edge case tests
✅ Async operation tests

Running Tests

Open project in Xcode
Press ⌘+U to run all tests
View test results in Test Navigator

Test Commands
bash# Run all tests
xcodebuild test -scheme CountriesApp -destination 'platform=iOS Simulator,name=iPhone 14'

# Run specific test class
xcodebuild test -scheme CountriesApp -destination 'platform=iOS Simulator,name=iPhone 14' -only-testing:CountriesAppTests/CountryTests

# Generate test coverage report
xcodebuild test -scheme CountriesApp -destination 'platform=iOS Simulator,name=iPhone 14' -enableCodeCoverage YES
Offline Support
The app provides offline functionality through:

Local Storage: Saves favorite countries and all fetched countries
UserDefaults: Persistent storage across app launches
Graceful Fallback: Works with cached data when network unavailable

Error Handling
Network Errors

Invalid URL handling
No internet connection
API service unavailable
Malformed JSON response

Location Errors

Permission denied
Location services disabled
GPS unavailable
Geocoding failures

App Errors

Maximum favorites limit (5 countries)
Duplicate country additions
Empty search results

Performance Optimizations

Lazy Loading: Efficient list rendering with LazyVGrid
Search Debouncing: Optimized search performance
Memory Management: Proper use of @Published and @StateObject
Offline Caching: Reduces API calls and improves performance

Accessibility

VoiceOver Support: Proper accessibility labels
Dynamic Type: Supports system font scaling
Color Contrast: Ensures readable text colors
Navigation: Logical navigation flow

Future Enhancements
Potential Features

 Country flags display
 Population and area information
 Map integration
 Sharing functionality
 Dark mode support
 Multiple language support
 Search history
 Country comparison feature

Technical Improvements

 Core Data implementation
 Combine framework integration
 Background app refresh
 Widget support
 Watch app companion

Troubleshooting
Common Issues

Location Not Working

Ensure location permissions are granted
Check device location services are enabled
Verify GPS signal availability


Countries Not Loading

Check internet connection
Verify API endpoint accessibility
Review network security settings


App Crashes

Check Xcode console for error messages
Verify iOS version compatibility
Ensure proper memory management



Debug Tips

Enable network logging for API debugging
Use location simulator for testing
Monitor memory usage during testing
Check UserDefaults for stored data

License
This project is created for educational and demonstration purposes.
Contact
For questions or support regarding this Countries App implementation, please refer to the code documentation and unit tests for detailed usage examples.
