//
//  ContentView.swift
//  CountriesListApp
//
//  Created by Naval Hasan on 08/06/25.
//

import SwiftUI
import CoreData

struct CountryListView: View {
    @StateObject private var dataManager = CountriesDataManager()
    @StateObject private var locationManager = LocationManager()
    @State private var showingSearchView = false
    
    var body: some View {
        NavigationView {
            VStack {
                if dataManager.isLoading {
                    ProgressView("Loading countries...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    mainContentView
                }
            }
            .navigationTitle("My Countries")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingSearchView = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                    .disabled(dataManager.savedCountries.count >= 5)
                }
            }
            .sheet(isPresented: $showingSearchView) {
                SearchCountriesView(dataManager: dataManager)
            }
            .onAppear {
                setupInitialCountry()
            }
        }
    }
    
    private var mainContentView: some View {
        VStack {
            if dataManager.savedCountries.isEmpty {
                emptyStateView
            } else {
                savedCountriesView
            }
            
            Spacer()
            
            footerView
        }
        .padding()
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "globe")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Countries Added")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Tap the + button to add countries to your list")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var savedCountriesView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(dataManager.savedCountries) { country in
                    NavigationLink(destination: CountryDetailView(country: country)) {
                        CountryRowView(country: country) {
                            dataManager.removeCountry(country)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    private var footerView: some View {
        VStack(spacing: 8) {
            Text("\(dataManager.savedCountries.count)/5 countries added")
                .font(.caption)
                .foregroundColor(.secondary)
            
            if dataManager.savedCountries.count >= 5 {
                Text("Maximum limit reached")
                    .font(.caption)
                    .foregroundColor(.orange)
            }
        }
    }
    
    private func setupInitialCountry() {
        locationManager.requestLocation()
        
        // Add default country based on location after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if dataManager.savedCountries.isEmpty {
                let countryCode = locationManager.userCountryCode ?? "IN"
                if let country = dataManager.getCountryByCode(countryCode) {
                    dataManager.addCountry(country)
                }
            }
        }
    }
}
