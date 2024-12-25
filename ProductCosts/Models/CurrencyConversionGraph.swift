
import Foundation

protocol CurrencyConversionGraphProtocol {
    func convertToGBP(_ amount: Double,_ currency: String,_ rates: [RateModel]) -> Double
    func updateGraph(with rates: [RateModel])
}

final class CurrencyConversionGraph: CurrencyConversionGraphProtocol {
    private var graph: [String: [String: Double]] = [:]
    
    init(rates: [RateModel]) {
            buildGraph(from: rates)
        }
    
    func buildGraph(from rates: [RateModel]) {
        graph = [:]
        for rate in rates {
            graph[rate.from, default: [:]][rate.to] = rate.rate
        }
    }
    
    func updateGraph(with rates: [RateModel]) {
            buildGraph(from: rates)
        }
    
    func convertToGBP(_ amount: Double,_ currency: String,_ rates: [RateModel]) -> Double {
        if currency == "GBP" {
            return amount
        } else if let directRateToGBP = graph[currency]?["GBP"] {
            return amount * directRateToGBP
        } else if let rateToUSD = graph[currency]?["USD"],
                  let usdToGBP = graph["USD"]?["GBP"] {
            return amount * rateToUSD * usdToGBP
        }
        return 0.0
    }
}

