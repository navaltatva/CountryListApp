//
//  LocalStorageService.swift
//  CountriesListApp
//
//  Created by Naval Hasan on 08/06/25.
//

import Foundation

// MARK: - Local Storage Service
class LocalStorageService: ObservableObject {
    private let userDefaults = UserDefaults.standard
    private let savedCountriesKey = "SavedCountries"
    private let allCountriesKey = "AllCountries"
    
    func saveFavoriteCountries(_ countries: [Country]) {
        if let encoded = try? JSONEncoder().encode(countries) {
            userDefaults.set(encoded, forKey: savedCountriesKey)
        }
    }
    
    func loadFavoriteCountries() -> [Country] {
        guard let data = userDefaults.data(forKey: savedCountriesKey),
              let countries = try? JSONDecoder().decode([Country].self, from: data) else {
            return []
        }
        return countries
    }
    
    func saveAllCountries(_ countries: [Country]) {
        if let encoded = try? JSONEncoder().encode(countries) {
            userDefaults.set(encoded, forKey: allCountriesKey)
        }
    }
    
    func loadAllCountries() -> [Country] {
        guard let data = userDefaults.data(forKey: allCountriesKey),
              let countries = try? JSONDecoder().decode([Country].self, from: data) else {
            return []
        }
        return countries
    }
}
