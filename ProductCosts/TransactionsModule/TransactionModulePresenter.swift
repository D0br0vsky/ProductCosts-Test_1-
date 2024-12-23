import Foundation

protocol TransactionModulePresenterProtocol: AnyObject {
    var tittle: String { get }
    func viewDidLoad()
}

final class TransactionModulePresenter: TransactionModulePresenterProtocol {
    var tittle: String { "\(operationModel.sku)" }
    weak var view: TransactionModuleViewProtocol?
    private let operationModel: OperationModel
    private let service: DataServiceProtocol
    private var ratesDataStorage: RatesDataStorageProtocol
    private var currencyFormatter: CurrencyFormattingServiceProtocol
    private var conversionModel: [СonversionModel] = []
    
    
    init(operationModel: OperationModel, service: DataServiceProtocol, ratesDataStorage: RatesDataStorageProtocol, dataRateConvertor: CurrencyFormattingServiceProtocol) {
        self.service = service
        self.operationModel = operationModel
        self.ratesDataStorage = ratesDataStorage
        self.currencyFormatter = dataRateConvertor
    }
    
    func viewDidLoad() {
        ratesLoad()
    }
}

extension TransactionModulePresenter {
    func ratesLoad() {
        view?.startLoader()
        let ratesValues = ratesDataStorage.getRates()
        convertingReplacingValues(operationModel, ratesValues)
        updateUI()
        view?.stopLoader()
    }
}

// MARK: - Extension private
private extension TransactionModulePresenter {
    func updateUI() {
        guard !conversionModel.isEmpty else {
            view?.showEmpty()
            return
        }
        let items: [TransactionModuleViewCell.Model] = conversionModel.map { value in
                .init(amountAndCurrency: value.amountAndCurrency, amountConvertGBP: value.convertGBP)
        }
        
        let totalCount = conversionModel
            .compactMap { Double($0.totalCount) }
            .reduce(0, +)
        let formattedTotalCount = "Total: £\(String(format: "%.2f", totalCount))"
        let viewModel = TransactionModuleView.Model(items: items, totalCount: formattedTotalCount)
        view?.update(model: viewModel)
    }
    
    func convertingReplacingValues(_ operationModel: OperationModel, _ ratesNewValues: [RateModel]) {
        var graph: [String: [String: Double]] = [:]
        for rate in ratesNewValues {
            graph[rate.from, default: [:]][rate.to] = rate.rate
        }

        for transaction in operationModel.transactionModel {
            var convertedAmount: Double = 0.0
            if transaction.currency == "GBP" {
                convertedAmount = transaction.amount
            }
            else if let directRateToGBP = graph[transaction.currency]?["GBP"] {
                convertedAmount = transaction.amount * directRateToGBP
            }
            else if let rateToUSD = graph[transaction.currency]?["USD"],
                    let usdToGBP = graph["USD"]?["GBP"] {
                convertedAmount = transaction.amount * rateToUSD * usdToGBP
            }
            
            let amountAndCurrency = currencyFormatter.convertToCurrencyString(transaction.amount, transaction.currency)
            
            let conversionItem = СonversionModel(
                convertGBP: "£ \(String(format: "%.2f", convertedAmount))",
                totalCount: "\(convertedAmount)",
                amountAndCurrency: amountAndCurrency
            )
            conversionModel.append(conversionItem)
        }
    }
}
