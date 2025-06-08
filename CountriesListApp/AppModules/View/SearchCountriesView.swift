//
//  SearchCountriesView.swift
//  CountriesListApp
//
//  Created by Naval Hasan on 08/06/25.
//

import SwiftUI

struct SearchCountriesView: View {
    @ObservedObject var dataManager: CountriesDataManager
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    
    var filteredCountries: [Country] {
        dataManager.searchCountries(query: searchText)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                
                List(filteredCountries) { country in
                    CountrySearchRowView(country: country) {
                        dataManager.addCountry(country)
                        dismiss()
                    }
                    .disabled(dataManager.savedCountries.contains(country) || dataManager.savedCountries.count >= 5)
                }
            }
            .navigationTitle("Add Country")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

extension SearchCountriesView {
    struct SearchBar: View {
        @Binding var text: String
        
        var body: some View {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Search countries or capitals...", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal)
        }
    }
}
