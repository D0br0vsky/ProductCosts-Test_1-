import Foundation

protocol TransactionModulePresenterProtocol: AnyObject {
    var title: String { get }
    func viewDidLoad()
}

final class TransactionModulePresenter: TransactionModulePresenterProtocol {
    var title: String { operationModel.sku }
    weak var view: TransactionModuleViewProtocol?
    private let operationModel: OperationModel
    private let service: DataServiceProtocol
    private let ratesDataStorage: RatesDataStorageProtocol
    private let transactionConverter: TransactionConverterProtocol
    private let currencyConversionGraph: CurrencyConversionGraphProtocol
    
    private var conversionModel: [СonversionModel] = []
    
    init(operationModel: OperationModel, service: DataServiceProtocol, ratesDataStorage: RatesDataStorageProtocol, transactionConverter: TransactionConverterProtocol, currencyConversionGraph: CurrencyConversionGraphProtocol) {
        self.service = service
        self.operationModel = operationModel
        self.ratesDataStorage = ratesDataStorage
        self.transactionConverter = transactionConverter
        self.currencyConversionGraph = currencyConversionGraph
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

// MARK: - Private Helpers
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
        currencyConversionGraph.updateGraph(with: ratesNewValues)
        conversionModel = operationModel.transactionModel.map { transactionModel in
            transactionConverter.makeConversionModel(transactionModel, ratesNewValues)
        }
    }
}
