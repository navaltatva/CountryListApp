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
    }
    
    override func tearDown() {
        dataManager = nil
        super.tearDown()
    }
    
    func testCountriesLoading() {
        // Wait for async loading
        let expectation = XCTestExpectation(description: "Countries loaded")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertFalse(self.dataManager.countries.isEmpty, "Countries should be loaded")
            XCTAssertFalse(self.dataManager.isLoading, "Loading should be completed")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testSearchFunctionality() {
        // Test search with country name
        let searchResults = dataManager.searchCountries(query: "India")
        XCTAssertTrue(searchResults.contains { $0.name.contains("India") }, "Search should return India")
        
        // Test search with capital
        let capitalResults = dataManager.searchCountries(query: "London")
        XCTAssertTrue(capitalResults.contains { $0.capital.contains("London") }, "Search should return country with London as capital")
        
        // Test empty search
        let emptyResults = dataManager.searchCountries(query: "")
        XCTAssertEqual(emptyResults.count, dataManager.countries.count, "Empty search should return all countries")
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
        
        // Test adding country
        dataManager.addCountry(testCountry)
        XCTAssertTrue(dataManager.savedCountries.contains(testCountry), "Country should be added")
        
        // Test removing country
        dataManager.removeCountry(testCountry)
        XCTAssertFalse(dataManager.savedCountries.contains(testCountry), "Country should be removed")
    }
    
    func testMaximumCountriesLimit() {
        // Clear saved countries
        dataManager.savedCountries.removeAll()
        
        // Add 6 countries (should only add 5)
        for i in 0..<6 {
            let testCountry = Country(
                name: "Test Country \\(i)",
                capital: "Test Capital \\(i)",
                currencies: [Currency(code: "TC\\(i)", name: "Test Currency \\(i)", symbol: "T")],
                alpha2Code: "T\\(i)",
                region: "Test Region",
                population: 1000000,
                area: 50000,
                flag: "🏳️"
            )
            dataManager.addCountry(testCountry)
        }
        
        XCTAssertEqual(dataManager.savedCountries.count, 5, "Should not exceed 5 countries limit")
    }
    
    func testGetCountryByCode() {
        let country = dataManager.getCountryByCode("IN")
        XCTAssertNotNil(country, "Should find country by code")
        XCTAssertEqual(country?.alpha2Code, "IN", "Should return correct country")
        
        let nonExistentCountry = dataManager.getCountryByCode("XX")
        XCTAssertNil(nonExistentCountry, "Should return nil for non-existent country code")
    }
}
