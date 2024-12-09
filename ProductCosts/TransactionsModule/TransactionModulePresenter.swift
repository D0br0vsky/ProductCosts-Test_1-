
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
                let ratesNewValues = dtoRates.compactMap { DefaultMapper().rateConverter(dto: $0) }
                convertingReplacingValues(operationModel, ratesNewValues)
                updateUI()
            case .failure(_):
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
        
        let totalCount = conversionModel
            .compactMap { Double($0.totalCount) }
            .reduce(0, +)
        let formattedTotalCount = "Total: £\(String(format: "%.2f", totalCount))"
        let viewModel = TransactionModuleView.Model(items: items, totalCount: formattedTotalCount)
        view?.update(model: viewModel)
    }
    
    func convertingReplacingValues(_ operationModel: OperationModel, _ ratesNewValues: [RateModel]) {
        let characterEncoding: [String: String] = ["USD":"$", "GBP":"£", "CAD":"CA$", "AUD":"A$"]
        var totalConvertedAmounts: [Double] = []
        let ratesDictionary: [String: Double] = ratesNewValues.reduce(into: [:]) { result, rate in
            guard rate.to != "CAD" else { return }
            result[rate.from] = rate.rate
        }
        let usdRate = ratesDictionary["USD"] ?? 1.0
        
        for transaction in operationModel.transactionModel {
            var convertedAmount: Double = 0.0
            
            if transaction.currency == "GBP" {
                convertedAmount = transaction.amount
            } else if let rate = ratesDictionary[transaction.currency] {
                switch transaction.currency {
                case "GBP":
                    convertedAmount = transaction.amount
                case "CAD":
                    convertedAmount = transaction.amount * rate * usdRate
                case "AUD":
                    convertedAmount = transaction.amount * rate
                case "USD":
                    convertedAmount = transaction.amount * usdRate
                default:
                    print("Unsupported currency")
                }
            }
            
            totalConvertedAmounts.append(convertedAmount)
            let currencySymbol = characterEncoding[transaction.currency] ?? transaction.currency
            let amountAndCurrency = "\(currencySymbol)\(String(format: "%.2f", transaction.amount))"
            let conversionItem = СonversionModel(
                convertGBP: "£ \(String(format: "%.2f", convertedAmount))",
                totalCount: "\(convertedAmount)",
                amountAndCurrency: amountAndCurrency,
                rateModel: ratesNewValues
            )
            conversionModel.append(conversionItem)
        }
    }
}
