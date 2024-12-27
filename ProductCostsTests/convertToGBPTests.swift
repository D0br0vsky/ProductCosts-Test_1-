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
        
        let result = currencyConversionGraph.convertToGBP(enteredAmount, enteredCurrency)
        
        XCTAssertEqual(result, 100.0)
    }
    
    func testDirectConversionToGBP() {
        let rates = [
            RateModel(from: "CAD", rate: 0.7084, to: "GBP")
        ]
        
        let currencyConversionGraph = CurrencyConversionGraph(rates: rates)

        let enteredAmount = 100.00
        let enteredCurrency = "CAD"
        
        let result = currencyConversionGraph.convertToGBP(enteredAmount, enteredCurrency)
        
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
        
        let result = currencyConversionGraph.convertToGBP(enteredAmount, enteredCurrency)
        
        XCTAssertEqual(result, 70.84)
    }
    
    
    func testNoConversionRateAvailable() {
        let rates = [
            RateModel(from: "USD", rate: 0.77, to: "GBP")
        ]
        
        let currencyConversionGraph = CurrencyConversionGraph(rates: rates)

        let enteredAmount = 100.00
        let enteredCurrency = "YAN"
        
        let result = currencyConversionGraph.convertToGBP(enteredAmount, enteredCurrency)
        
        XCTAssertEqual(result, 0.0)
    }
    
    func testBuildGraphSuccessfully() {
        let rates = [
            RateModel(from: "USD", rate: 0.77, to: "GBP")
        ]
        let currencyConversionGraph = CurrencyConversionGraph(rates: rates)

        currencyConversionGraph.buildGraph(from: rates)

        let expectedGraph = ["USD": ["GBP": 0.77]]
            XCTAssertEqual(currencyConversionGraph.graph, expectedGraph)
    }
    
    func testUpdateGraphSuccessfully(){
        let initialRates = [
                RateModel(from: "USD", rate: 0.77, to: "GBP")
            ]
            
            let updatedRates = [
                RateModel(from: "AUD", rate: 1.20, to: "GBP")
            ]
        
        let currencyConversionGraph = CurrencyConversionGraph(rates: initialRates)

        currencyConversionGraph.updateGraph(with: updatedRates)

        let expectedGraph = ["AUD": ["GBP": 1.20]]
            XCTAssertEqual(currencyConversionGraph.graph, expectedGraph)
    }
}

