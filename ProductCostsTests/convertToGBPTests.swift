//
//  convertToGBPTests.swift
//  ProductCostsTests
//
//  Created by Dobrovsky on 24.12.2024.
//

import XCTest

@testable import ProductCosts

final class convertToGBPTests: XCTestCase {

    func testSuccessfulCurrencyConversion() {
        let rates = [
            RateModel(from: "CAD", rate: 0.58, to: "GBP"),
            RateModel(from: "USD", rate: 0.72, to: "GBP"),
            RateModel(from: "CAD", rate: 0.80, to: "USD")
                ]
        
        let currencyConversionGraph = CurrencyConversionGraph(rates: rates)
        let enteredAmount = 73.21
        let enteredCurrency = "CAD"
        
        let value = currencyConversionGraph.convertToGBP(enteredAmount, enteredCurrency, rates)
        
        XCTAssertEqual(value, 42.4618)
    }
    
    func testCurrencyWithoutConversionRate() {
        let rates = [
            RateModel(from: "CAD", rate: 0.58, to: "GBP"),
            RateModel(from: "USD", rate: 0.72, to: "GBP"),
            RateModel(from: "CAD", rate: 0.80, to: "USD")
                ]
        
        let currencyConversionGraph = CurrencyConversionGraph(rates: rates)
        let enteredAmount = 73.21
        let enteredCurrency = "CHF"
        
        let value = currencyConversionGraph.convertToGBP(enteredAmount, enteredCurrency, rates)
        
        XCTAssertEqual(value, 0.0)
    }
}

