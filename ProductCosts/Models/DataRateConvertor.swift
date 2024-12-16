
import Foundation

protocol DataRateConvertorProtocol {
    func currencyFormatting(_ value: Double,_ currencyCode: String) -> String
}

class DataRateConvertor: DataRateConvertorProtocol {
    func currencyFormatting(_ value: Double,_ currencyCode: String) -> String {
        let fomatter = NumberFormatter()
        fomatter.numberStyle = .currency
        fomatter.currencyCode = currencyCode
        return fomatter.string(from: NSNumber(value: value)) ?? "no data"
    }
}
