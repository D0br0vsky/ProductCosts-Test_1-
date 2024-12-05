
protocol TransactionModulePresenterProtocol: AnyObject {
    var tittle: String { get }
    func viewDidLoad()
}

final class TransactionModulePresenter: TransactionModulePresenterProtocol {
    
    private let service: DataServiceProtocol
    private let operationModel: OperationModel
    private var rates: [RateModel] = []
    private var symbolsDifferentCurrencies: [String] = []
    
    var tittle: String { "\(operationModel.sku)" }
    
    
    weak var view: TransactionModuleViewProtocol?
    
    init(operationModel: OperationModel, service: DataServiceProtocol) {
        self.service = service
        self.operationModel = operationModel
    }
    
    // MARK: - Protocol Methods
    func viewDidLoad() {
        ratesViewDidLoad()
    }
    
    
    
}

// MARK: - ViewDidLoad
extension TransactionModulePresenter {
    func ratesViewDidLoad() {
        view?.startLoader()
        service.fetchRates { [weak self] result in
            guard let self = self else { return }
            self.view?.stopLoader()
            switch result {
            case .success(let dtoRates):
                rates = dtoRates.compactMap { DefaultMapper().rateMapper(dto: $0) }
                
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
        
    }
    
    func indicatorSymbols(_ transactions: TransactionModel) -> [String] {
        // transactions.amount
        // transactions.currency
        
        if transactions.currency == "USD" {
            symbolsDifferentCurrencies.append("$") 
            
        }
        return ["Fun"]
    }
    
    func convertGBP() {
        // потом поправить и обновитть модель в Cell amountConvertGBP
    }
}

