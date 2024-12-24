
import Foundation

protocol TransactionConverterProtocol {
    func makeConversionModel(_ transaction: TransactionModel,_ rates: [RateModel]) -> СonversionModel
}

final class TransactionConverter: TransactionConverterProtocol {
    private let currencyConversionGraph: CurrencyConversionGraphProtocol
    private let currencyFormatter: CurrencyFormatterProtocol
    
    init(currencyConversionGraph: CurrencyConversionGraph, currencyFormatter: CurrencyFormatter) {
        self.currencyConversionGraph = currencyConversionGraph
        self.currencyFormatter = currencyFormatter
    }
    
    func makeConversionModel(_ transaction: TransactionModel,_ rates: [RateModel]) -> СonversionModel {
        let convertedAmount = currencyConversionGraph.convertToGBP(transaction.amount, transaction.currency, rates)
        let amountAndCurrency = currencyFormatter.convertToCurrencyString(transaction.amount, transaction.currency)
        return СonversionModel(
            convertGBP: "£ \(String(format: "%.2f", convertedAmount))",
            totalCount: "\(convertedAmount)",
            amountAndCurrency: amountAndCurrency
        )
    }
}
