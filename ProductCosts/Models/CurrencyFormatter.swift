
import Foundation

protocol CurrencyFormatterProtocol {
    func convertToCurrencyString(_ value: Double, _ currencyCode: String) -> String
}

class CurrencyFormatter: CurrencyFormatterProtocol {
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
}
