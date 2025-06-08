//
//  CountryRowView.swift
//  CountriesListApp
//
//  Created by Naval Hasan on 08/06/25.
//

import SwiftUI

extension CountryListView {
    struct CountryRowView: View {
        let country: Country
        let onRemove: () -> Void
        
        var body: some View {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(country.flag)
                            .font(.title2)
                        
                        Text(country.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Label(country.capital, systemImage: "building.2")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    }
                    
                    if let currency = country.currencies.first {
                        HStack {
                            Label("\(currency.code) (\(currency.symbol ?? ""))", systemImage: "banknote")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                        }
                    }
                }
                
                Button(action: onRemove) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.red)
                        .font(.title3)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
    }
}

