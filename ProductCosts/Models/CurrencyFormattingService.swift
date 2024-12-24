
import Foundation

protocol CurrencyFormattingServiceProtocol {
    func convertToCurrencyString(_ value: Double, _ currencyCode: String) -> String
    func convertToGBP(_ amount: Double,_ currency: String,_ rates: [RateModel]) -> Double
    func makeConversionModel(_ transaction: TransactionModel,_ rates: [RateModel]) -> СonversionModel
}

class CurrencyFormatter: CurrencyFormattingServiceProtocol {
    private var graph: [String: [String: Double]] = [:]
    private lazy var currencyLocale: NSLocale = NSLocale(localeIdentifier: "en_US")
    private lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.currencySymbol = ""
        formatter.numberStyle = .currency
        return formatter
    }()
    
    func convertToCurrencyString(_ value: Double, _ currencyCode: String) -> String {
        let currencySymbol = currencyLocale.displayName(forKey: .currencySymbol, value: currencyCode) ?? currencyCode
        formatter.positivePrefix = "\(currencySymbol) "
        formatter.negativePrefix = "-\(currencySymbol) "
        
        return formatter.string(from: NSNumber(value: value)) ?? "no data"
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
    
    func makeConversionModel(_ transaction: TransactionModel,_ rates: [RateModel]) -> СonversionModel {
        let convertedAmount = convertToGBP(transaction.amount, transaction.currency, rates)
        let amountAndCurrency = convertToCurrencyString(transaction.amount, transaction.currency)
        return СonversionModel(
            convertGBP: "£ \(String(format: "%.2f", convertedAmount))",
            totalCount: "\(convertedAmount)",
            amountAndCurrency: amountAndCurrency
        )
    }
}

// MARK: - Private Helpers
extension CurrencyFormatter {
    func buildGraph(from rates: [RateModel]) {
        guard graph.isEmpty else { return }
        for rate in rates {
            graph[rate.from, default: [:]][rate.to] = rate.rate
        }
    }
}
