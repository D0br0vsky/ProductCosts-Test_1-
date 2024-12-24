
import Foundation

protocol CurrencyConversionGraphProtocol {
    func convertToGBP(_ amount: Double,_ currency: String,_ rates: [RateModel]) -> Double
}

final class CurrencyConversionGraph: CurrencyConversionGraphProtocol {
    private var graph: [String: [String: Double]] = [:]
    
    func buildGraph(from rates: [RateModel]) {
        guard graph.isEmpty else { return }
        for rate in rates {
            graph[rate.from, default: [:]][rate.to] = rate.rate
        }
    }
    
    func convertToGBP(_ amount: Double,_ currency: String,_ rates: [RateModel]) -> Double {
        buildGraph(from: rates)
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
