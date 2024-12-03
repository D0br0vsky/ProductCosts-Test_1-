
protocol TransactionModulePresenterProtocol: AnyObject {
    var tittle: String { get }
    func viewDidLoad()
}

final class TransactionModulePresenter: TransactionModulePresenterProtocol {
    
    private let service: DataServiceProtocol
    let transaction: TransactionModel
    private var rates: [RateModel] = []
    
    var tittle: String { "\(transaction.sku)" }
    private var dod:[Int] = []
    
    weak var view: TransactionModuleViewProtocol?
    
    init(transaction: TransactionModel, service: DataServiceProtocol) {
        self.service = service
        self.transaction = transaction
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
    
    func indicatorSymbols(_ transactions: TransactionModel, _ rate: RateModel) -> String {
        // добавить
        return "Fun"
    }
    
    func convertGBP() {
        // потом поправить и обновитть модель в Cell amountConvertGBP
    }
}

