//
//  CountrySearchRowView.swift
//  CountriesListApp
//
//  Created by Naval Hasan on 08/06/25.
//

import SwiftUI

struct CountrySearchRowView: View {
    let country: Country
    let onAdd: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(country.flag)
                        .font(.title3)
                    
                    Text(country.name)
                        .font(.headline)
                    
                    Spacer()
                }
                
                Text("Capital: \(country.capital)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if let currency = country.currencies.first {
                    Text("Currency: \(currency.name) (\(currency.code))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Button(action: onAdd) {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
            }
        }
        .padding(.vertical, 4)
    }
}
