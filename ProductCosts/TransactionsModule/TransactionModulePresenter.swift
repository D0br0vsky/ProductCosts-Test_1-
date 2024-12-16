import Foundation

protocol TransactionModulePresenterProtocol: AnyObject {
    var tittle: String { get }
    func viewDidLoad()
}

final class TransactionModulePresenter: TransactionModulePresenterProtocol {
    private let service: DataServiceProtocol
    private let operationModel: OperationModel
    private var dataStorage: DataStorageProtocol
    private var conversionModel: [СonversionModel] = []
    
    //
    private var dataRateConvertor: DataRateConvertorProtocol
    //
    
    weak var view: TransactionModuleViewProtocol?
    var tittle: String { "\(operationModel.sku)" }
    
    init(operationModel: OperationModel, service: DataServiceProtocol, dataStorage: DataStorageProtocol, dataRateConvertor: DataRateConvertorProtocol) {
        self.service = service
        self.operationModel = operationModel
        self.dataStorage = dataStorage
        self.dataRateConvertor = dataRateConvertor
    }
    
    func viewDidLoad() {
        ratesLoad()
    }
}

extension TransactionModulePresenter {
    func ratesLoad() {
        view?.startLoader()
        let ratesValues = dataStorage.getRates()
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
        
        let rateDictionary: [String: Double] = ratesNewValues.reduce(into: [:]) { result, rate in
            result[rate.from] = rate.rate
        }
        
        for transaction in operationModel.transactionModel {
            var convertedAmount: Double = 0.0
            if transaction.currency == "GBP" {
                convertedAmount = transaction.amount
            } else if let rate = rateDictionary[transaction.currency] {
                if transaction.currency != "USD" {
                    convertedAmount = transaction.amount * rate
                }
            }
            
            let amountAndCurrency = dataRateConvertor.currencyFormatting(transaction.amount, transaction.currency)
            let conversionItem = СonversionModel(
                convertGBP: "£ \(String(format: "%.2f", convertedAmount))",
                totalCount: "\(convertedAmount)",
                amountAndCurrency: amountAndCurrency
            )
            conversionModel.append(conversionItem)
        }
    }
}

