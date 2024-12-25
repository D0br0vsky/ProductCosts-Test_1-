//
//  convertToGBPTests.swift
//  ProductCostsTests
//
//  Created by Dobrovsky on 24.12.2024.
//

import XCTest

@testable import ProductCosts

final class convertToGBPTests: XCTestCase {
    
    func testCurrencyIsAlreadyGBP() {
        let rates = [
            RateModel(from: "USD", rate: 0.77, to: "GBP")
                ]
        let currencyConversionGraph = CurrencyConversionGraph(rates: rates)

        let enteredAmount = 100.00
        let enteredCurrency = "GBP"
        
        let result = currencyConversionGraph.convertToGBP(enteredAmount, enteredCurrency, rates)
        
        XCTAssertEqual(result, 100.0)
    }
    
    func testDirectConversionToGBP() {
        let rates = [
            RateModel(from: "CAD", rate: 0.7084, to: "GBP")
        ]
        
        let currencyConversionGraph = CurrencyConversionGraph(rates: rates)

        let enteredAmount = 100.00
        let enteredCurrency = "CAD"
        
        let result = currencyConversionGraph.convertToGBP(enteredAmount, enteredCurrency, rates)
        
        XCTAssertEqual(result, 70.84)
    }
    
    func testConversionThroughIntermediateCurrency() {
        let rates = [
            RateModel(from: "CAD", rate: 0.92, to: "USD"),
            RateModel(from: "USD", rate: 0.77, to: "GBP")
        ]
        
        let currencyConversionGraph = CurrencyConversionGraph(rates: rates)

        let enteredAmount = 100.00
        let enteredCurrency = "CAD"
        
        let result = currencyConversionGraph.convertToGBP(enteredAmount, enteredCurrency, rates)
        
        XCTAssertEqual(result, 70.84)
    }
    
    
    func testNoConversionRateAvailable() {
        let rates = [
            RateModel(from: "USD", rate: 0.77, to: "GBP")
        ]
        
        let currencyConversionGraph = CurrencyConversionGraph(rates: rates)

        let enteredAmount = 100.00
        let enteredCurrency = "YAN"
        
        let result = currencyConversionGraph.convertToGBP(enteredAmount, enteredCurrency, rates)
        
        XCTAssertEqual(result, 0.0)
    }
}

