//
//  CountryModel.swift
//  CountriesListApp
//
//  Created by Naval Hasan on 08/06/25.
//

import Foundation

// MARK: - Models
struct Country: Codable, Identifiable {
    let name: String
    let capital: String?
    let alpha2Code: String
    let currencies: [Currency]?
    
    var id: String { alpha2Code }
    
    var displayCapital: String {
        capital ?? "N/A"
    }
    
    var displayCurrency: String {
        currencies?.first?.name ?? "N/A"
    }
    
    var displayCurrencyCode: String {
        currencies?.first?.code ?? "N/A"
    }
}

struct Currency: Codable {
    let code: String?
    let name: String?
    let symbol: String?
}
