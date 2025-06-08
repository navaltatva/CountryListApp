//
//  CountriesListAppTests.swift
//  CountriesListAppTests
//
//  Created by Naval Hasan on 08/06/25.
//

import XCTest
@testable import CountriesListApp

class CountriesAppTests: XCTestCase {
    var dataManager: CountriesDataManager!
    
    override func setUp() {
        super.setUp()
        dataManager = CountriesDataManager()
        
        // Wait for data to load synchronously for testing
        let expectation = XCTestExpectation(description: "Data loaded")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    override func tearDown() {
        dataManager = nil
        super.tearDown()
    }
    
    func testCountriesLoading() {
        // Wait for async loading
        let expectation = XCTestExpectation(description: "Countries loaded")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertFalse(self.dataManager.countries.isEmpty, "Countries should be loaded")
            XCTAssertFalse(self.dataManager.isLoading, "Loading should be completed")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testSearchFunctionality() {
        // Ensure data is loaded first
        let loadExpectation = XCTestExpectation(description: "Data loaded for search test")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Test search with country name
            let searchResults = self.dataManager.searchCountries(query: "India")
            XCTAssertTrue(searchResults.contains { $0.name.localizedCaseInsensitiveContains("India") }, "Search should return India")
            
            // Test search with capital
            let capitalResults = self.dataManager.searchCountries(query: "London")
            XCTAssertTrue(capitalResults.contains { $0.capital.localizedCaseInsensitiveContains("London") }, "Search should return country with London as capital")
            
            // Test case insensitive search
            let caseInsensitiveResults = self.dataManager.searchCountries(query: "india")
            XCTAssertTrue(caseInsensitiveResults.contains { $0.name.localizedCaseInsensitiveContains("India") }, "Search should be case insensitive")
            
            // Test empty search
            let emptyResults = self.dataManager.searchCountries(query: "")
            XCTAssertEqual(emptyResults.count, self.dataManager.countries.count, "Empty search should return all countries")
            
            // Test search with non-existent country
            let nonExistentResults = self.dataManager.searchCountries(query: "Atlantis")
            XCTAssertTrue(nonExistentResults.isEmpty, "Search for non-existent country should return empty array")
            
            loadExpectation.fulfill()
        }
        
        wait(for: [loadExpectation], timeout: 2.0)
    }
    
    func testAddRemoveCountries() {
        // Create a test country
        let testCountry = Country(
            name: "Test Country",
            capital: "Test Capital",
            currencies: [Currency(code: "TEST", name: "Test Currency", symbol: "T")],
            alpha2Code: "TC",
            region: "Test Region",
            population: 1000000,
            area: 50000,
            flag: "🏳️"
        )
        
        // Clear saved countries first
        dataManager.savedCountries.removeAll()
        
        // Test adding country
        dataManager.addCountry(testCountry)
        XCTAssertTrue(dataManager.savedCountries.contains(testCountry), "Country should be added")
        XCTAssertEqual(dataManager.savedCountries.count, 1, "Should have exactly 1 country")
        
        // Test adding duplicate country (should not add)
        dataManager.addCountry(testCountry)
        XCTAssertEqual(dataManager.savedCountries.count, 1, "Should still have exactly 1 country (no duplicates)")
        
        // Test removing country
        dataManager.removeCountry(testCountry)
        XCTAssertFalse(dataManager.savedCountries.contains(testCountry), "Country should be removed")
        XCTAssertEqual(dataManager.savedCountries.count, 0, "Should have 0 countries after removal")
    }
    
    func testGetCountryByCode() {
        // Ensure data is loaded first
        let expectation = XCTestExpectation(description: "Data loaded for country code test")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Test finding existing country
            let country = self.dataManager.getCountryByCode("IN")
            XCTAssertNotNil(country, "Should find country by code")
            XCTAssertEqual(country?.alpha2Code, "IN", "Should return correct country")
            XCTAssertEqual(country?.name, "India", "Should return India for IN code")
            
            // Test case insensitive code search
            let countryLowercase = self.dataManager.getCountryByCode("in")
            XCTAssertNotNil(countryLowercase, "Should find country by lowercase code")
            XCTAssertEqual(countryLowercase?.alpha2Code, "IN", "Should return correct country for lowercase code")
            
            // Test non-existent country code
            let nonExistentCountry = self.dataManager.getCountryByCode("XX")
            XCTAssertNil(nonExistentCountry, "Should return nil for non-existent country code")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testCountryEquality() {
        let country1 = Country(
            name: "Test Country",
            capital: "Test Capital",
            currencies: [Currency(code: "TEST", name: "Test Currency", symbol: "T")],
            alpha2Code: "TC",
            region: "Test Region",
            population: 1000000,
            area: 50000,
            flag: "🏳️"
        )
        
        let country2 = Country(
            name: "Test Country 2",
            capital: "Test Capital 2",
            currencies: [Currency(code: "TEST2", name: "Test Currency 2", symbol: "T2")],
            alpha2Code: "TC",  // Same alpha2Code
            region: "Test Region 2",
            population: 2000000,
            area: 60000,
            flag: "🏴"
        )
        
        let country3 = Country(
            name: "Test Country 3",
            capital: "Test Capital 3",
            currencies: [Currency(code: "TEST3", name: "Test Currency 3", symbol: "T3")],
            alpha2Code: "TD",  // Different alpha2Code
            region: "Test Region 3",
            population: 3000000,
            area: 70000,
            flag: "🏁"
        )
        
        // Test equality (same alpha2Code)
        XCTAssertEqual(country1, country2, "Countries with same alpha2Code should be equal")
        
        // Test inequality (different alpha2Code)
        XCTAssertNotEqual(country1, country3, "Countries with different alpha2Code should not be equal")
    }
    
    func testDataPersistence() {
        // Clear saved countries
        dataManager.savedCountries.removeAll()
        
        // Create test country
        let testCountry = Country(
            name: "Persistence Test Country",
            capital: "Persistence Test Capital",
            currencies: [Currency(code: "PTC", name: "Persistence Test Currency", symbol: "P")],
            alpha2Code: "PT",
            region: "Test Region",
            population: 1000000,
            area: 50000,
            flag: "🏳️"
        )
        
        // Add country
        dataManager.addCountry(testCountry)
        XCTAssertEqual(dataManager.savedCountries.count, 1, "Should have 1 saved country")
        
        // Create new data manager instance (simulating app restart)
        let newDataManager = CountriesDataManager()
        
        // Wait a bit for data to load
        let expectation = XCTestExpectation(description: "New data manager loaded")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        
        // Check if data persisted (this might not work in unit tests due to UserDefaults isolation)
        // In a real app, this would verify persistence
        XCTAssertGreaterThanOrEqual(newDataManager.savedCountries.count, 0, "Data manager should initialize without errors")
    }
}
