//
//  CountryService.swift
//  CountriesListApp
//
//  Created by Naval Hasan on 08/06/25.
//
import Foundation

// MARK: - Network Service
class CountryService: ObservableObject {
    static let shared = CountryService()
    private let baseURL = "https://restcountries.com/v2/all"
    
    func fetchAllCountries() async throws -> [Country] {
        guard let url = URL(string: baseURL) else {
            throw NetworkError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let countries = try JSONDecoder().decode([Country].self, from: data)
        return countries
    }
    
    func searchCountries(query: String, from countries: [Country]) -> [Country] {
        guard !query.isEmpty else { return countries }
        
        return countries.filter { country in
            country.name.localizedCaseInsensitiveContains(query) //||
           //country.displayCapital.localizedCaseInsensitiveContains(query)
        }
    }
}

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        }
    }
}
