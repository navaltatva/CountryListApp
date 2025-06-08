//
//  CountryDetailView.swift
//  CountriesListApp
//
//  Created by Naval Hasan on 08/06/25.
//

import SwiftUI

struct CountryDetailView: View {
    let country: Country
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header with flag and name
                VStack(spacing: 12) {
                    Text(country.flag)
                        .font(.system(size: 80))
                    
                    Text(country.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text(country.region)
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.top)
                
                Divider()
                
                // Details section
                VStack(alignment: .leading, spacing: 16) {
                    DetailRowView(title: "Capital", value: country.capital, icon: "building.2")
                    
                    if let currency = country.currencies.first {
                        DetailRowView(
                            title: "Currency",
                            value: "\(currency.name) (\(currency.code))\(currency.symbol.map { " \($0)" } ?? "")",
                            icon: "banknote"
                        )
                    }
                    
                    DetailRowView(
                        title: "Population",
                        value: NumberFormatter.localizedString(from: NSNumber(value: country.population), number: .decimal),
                        icon: "person.3"
                    )
                    
                    if let area = country.area {
                        DetailRowView(
                            title: "Area",
                            value: "\\(NumberFormatter.localizedString(from: NSNumber(value: area), number: .decimal)) km²",
                            icon: "map"
                        )
                    }
                    
                    DetailRowView(title: "Region", value: country.region, icon: "globe")
                    
                    DetailRowView(title: "Country Code", value: country.alpha2Code, icon: "flag")
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Country Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
