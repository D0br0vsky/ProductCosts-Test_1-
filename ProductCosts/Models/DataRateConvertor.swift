
import Foundation

protocol DataRateConvertorProtocol {
    func currencyFormatting(_ value: Double,_ currencyCode: String) -> String
}

class DataRateConvertor: DataRateConvertorProtocol {
    func currencyFormatting(_ value: Double, _ currencyCode: String) -> String {
        let locale = NSLocale(localeIdentifier: "en_US")
        let currencySymbol = locale.displayName(forKey: .currencySymbol, value: currencyCode) ?? currencyCode
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        formatter.currencySymbol = ""
        formatter.positivePrefix = "\(currencySymbol) "
        formatter.negativePrefix = "-\(currencySymbol) "
        
        return formatter.string(from: NSNumber(value: value)) ?? "no data"
    }
}
