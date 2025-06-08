//
//  CountryModel.swift
//  CountriesListApp
//
//  Created by Naval Hasan on 08/06/25.
//

import Foundation

// MARK: - Models
struct Country: Codable, Identifiable, Equatable {
    let id = UUID()
    let name: String
    let capital: String
    let currencies: [Currency]
    let alpha2Code: String
    let region: String
    let population: Int
    let area: Double?
    let flag: String
    
    enum CodingKeys: String, CodingKey {
        case name, capital, currencies, alpha2Code, region, population, area, flag
    }
    
    static func == (lhs: Country, rhs: Country) -> Bool {
        return lhs.alpha2Code == rhs.alpha2Code
    }
}

struct Currency: Codable {
    let code: String?
    let name: String?
    let symbol: String?
}
