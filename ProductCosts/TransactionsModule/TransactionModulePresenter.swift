
protocol TransactionModulePresenterProtocol: AnyObject {
    var tittle: String { get }
    func viewDidLoad()
}

final class TransactionModulePresenter: TransactionModulePresenterProtocol {
    
    private let service: DataServiceProtocol
    private let operationModel: OperationModel
    private var conversionModel: [СonversionModel] = []
    
    var tittle: String { "\(operationModel.sku)" }
    
    weak var view: TransactionModuleViewProtocol?
    
    init(operationModel: OperationModel, service: DataServiceProtocol) {
        self.service = service
        self.operationModel = operationModel
    }
    
    // MARK: - Protocol Methods
    func viewDidLoad() {
        ratesLoad()
    }
}

extension TransactionModulePresenter {
    func ratesLoad() {
        view?.startLoader()
        service.fetchRates { [weak self] result in
            guard let self = self else { return }
            self.view?.stopLoader()
            switch result {
            case .success(let dtoRates):
                let ratesNewValues = dtoRates.compactMap { DefaultMapper().rateMapper(dto: $0) }
                convertingReplacingValues(operationModel, ratesNewValues)
                
                
                updateUI()
            case .failure(let error):
                self.view?.showError()
            }
        }
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
        let viewModel = TransactionModuleView.Model(items: items, totalCount: "Test")
        view?.update(model: viewModel)
    }
    
    func convertingReplacingValues(_ operationModel: OperationModel, _ ratesNewValues: [RateModel]) {
        
        let characterEncoding: [String: String] = ["USD":"$", "GBP":"£", "CAD":"CA$", "AUD":"A$"]
        var totalConvertedAmounts: [Double] = []
        
        for transaction in operationModel.transactionModel {
            var convertedAmount: Double = 0.0
            
            if let rate = ratesNewValues.first(where: { $0.from == transaction.currency }) {
                convertedAmount = transaction.amount * rate.rate
            } else {
                convertedAmount = transaction.amount
            }
            totalConvertedAmounts.append(convertedAmount)
            
            let currencySymbol = characterEncoding[transaction.currency] ?? transaction.currency
            let amountAndCurrency = "\(currencySymbol)\(String(format: "%.2f", transaction.amount))"
            let conversionItem = СonversionModel(
                convertGBP: "£\(String(format: "%.2f", convertedAmount))",
                totalCount: "\(totalConvertedAmounts.reduce(0, +)) transactions",
                amountAndCurrency: amountAndCurrency,
                rateModel: ratesNewValues
            )
            conversionModel.append(conversionItem)
        }
    }
}
