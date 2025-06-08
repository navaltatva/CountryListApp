//
//  CountriesDataManager.swift
//  CountriesListApp
//
//  Created by Naval Hasan on 08/06/25.
//

import Foundation

// MARK: - Data Manager
class CountriesDataManager: ObservableObject {
    @Published var countries: [Country] = []
    @Published var savedCountries: [Country] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let userDefaults = UserDefaults.standard
    private let savedCountriesKey = "SavedCountries"
    
    init() {
        loadCountriesFromJSON()
        loadSavedCountries()
    }
    
    private func loadCountriesFromJSON() {
        isLoading = true
        
        // Sample countries data (you can replace this with your JSON file)
        let jsonData = """
        [
            {
                "name": "India",
                "capital": "New Delhi",
                "currencies": [{"code": "INR", "name": "Indian rupee", "symbol": "₹"}],
                "alpha2Code": "IN",
                "region": "Asia",
                "population": 1380004385,
                "area": 3287590.0,
                "flag": "🇮🇳"
            },
            {
                "name": "United States of America",
                "capital": "Washington, D.C.",
                "currencies": [{"code": "USD", "name": "United States dollar", "symbol": "$"}],
                "alpha2Code": "US",
                "region": "Americas",
                "population": 329484123,
                "area": 9629091.0,
                "flag": "🇺🇸"
            },
            {
                "name": "United Kingdom",
                "capital": "London",
                "currencies": [{"code": "GBP", "name": "British pound", "symbol": "£"}],
                "alpha2Code": "GB",
                "region": "Europe",
                "population": 67886011,
                "area": 242495.0,
                "flag": "🇬🇧"
            },
            {
                "name": "Germany",
                "capital": "Berlin",
                "currencies": [{"code": "EUR", "name": "Euro", "symbol": "€"}],
                "alpha2Code": "DE",
                "region": "Europe",
                "population": 83240525,
                "area": 357114.0,
                "flag": "🇩🇪"
            },
            {
                "name": "France",
                "capital": "Paris",
                "currencies": [{"code": "EUR", "name": "Euro", "symbol": "€"}],
                "alpha2Code": "FR",
                "region": "Europe",
                "population": 67391582,
                "area": 640679.0,
                "flag": "🇫🇷"
            },
            {
                "name": "Japan",
                "capital": "Tokyo",
                "currencies": [{"code": "JPY", "name": "Japanese yen", "symbol": "¥"}],
                "alpha2Code": "JP",
                "region": "Asia",
                "population": 125836021,
                "area": 377930.0,
                "flag": "🇯🇵"
            },
            {
                "name": "Australia",
                "capital": "Canberra",
                "currencies": [{"code": "AUD", "name": "Australian dollar", "symbol": "$"}],
                "alpha2Code": "AU",
                "region": "Oceania",
                "population": 25687041,
                "area": 7692024.0,
                "flag": "🇦🇺"
            },
            {
                "name": "Brazil",
                "capital": "Brasília",
                "currencies": [{"code": "BRL", "name": "Brazilian real", "symbol": "R$"}],
                "alpha2Code": "BR",
                "region": "Americas",
                "population": 212559417,
                "area": 8515767.0,
                "flag": "🇧🇷"
            },
            {
                "name": "Canada",
                "capital": "Ottawa",
                "currencies": [{"code": "CAD", "name": "Canadian dollar", "symbol": "$"}],
                "alpha2Code": "CA",
                "region": "Americas",
                "population": 38005238,
                "area": 9984670.0,
                "flag": "🇨🇦"
            },
            {
                "name": "China",
                "capital": "Beijing",
                "currencies": [{"code": "CNY", "name": "Chinese yuan", "symbol": "¥"}],
                "alpha2Code": "CN",
                "region": "Asia",
                "population": 1439323776,
                "area": 9596961.0,
                "flag": "🇨🇳"
            }
        ]
        """.data(using: .utf8)!
        
        do {
            let decodedCountries = try JSONDecoder().decode([Country].self, from: jsonData)
            DispatchQueue.main.async {
                self.countries = decodedCountries
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to load countries data: \\(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
    
    func searchCountries(query: String) -> [Country] {
        if query.isEmpty {
            return countries
        }
        return countries.filter { country in
            country.name.localizedCaseInsensitiveContains(query) ||
            country.capital.localizedCaseInsensitiveContains(query)
        }
    }
    
    func addCountry(_ country: Country) {
        if savedCountries.count < 5 && !savedCountries.contains(country) {
            savedCountries.append(country)
            saveSavedCountries()
        }
    }
    
    func removeCountry(_ country: Country) {
        savedCountries.removeAll { $0.alpha2Code == country.alpha2Code }
        saveSavedCountries()
    }
    
    func getCountryByCode(_ code: String) -> Country? {
        return countries.first { $0.alpha2Code.lowercased() == code.lowercased() }
    }
    
    private func saveSavedCountries() {
        if let encoded = try? JSONEncoder().encode(savedCountries) {
            userDefaults.set(encoded, forKey: savedCountriesKey)
        }
    }
    
    private func loadSavedCountries() {
        if let data = userDefaults.data(forKey: savedCountriesKey),
           let decoded = try? JSONDecoder().decode([Country].self, from: data) {
            savedCountries = decoded
        }
    }
}
