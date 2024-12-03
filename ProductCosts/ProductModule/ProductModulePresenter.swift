
protocol ProductModulePresenterProtocol {
    var title: String { get }
    func tapRow(index: Int)
    func viewDidLoad()
}

final class ProductModulePresenter: ProductModulePresenterProtocol {
    
    weak var view: ProductModuleViewProtocol?
    var title: String { "Product" }
    
    private let service: DataServiceProtocol
    private let router: ProductModuleRouter
    
    private var model: [TransactionModel]?
    private var groupedTransactions: [OperationModel] = []
    
    private var transactions: [TransactionModel] = []
    private var rates: [RateModel] = []
 
    // MARK: - Init
    init(service: DataServiceProtocol, router: ProductModuleRouter) {
        self.service = service
        self.router = router
    }
    
    
    // MARK: - Protocol Methods
    func viewDidLoad() {
        func viewDidLoad() {
            transactionsViewDidLoad()
            ratesViewDidLoad()
        }
    }
    
    func tapRow(index: Int) {
        guard transactions.indices.contains(index) else { return }
        let selectedTransaction = transactions[index]
        router.openModuleTransaction(with: selectedTransaction, rate: rates)
    }
}

// MARK: - ViewDidLoad
extension ProductModulePresenter {
    func transactionsViewDidLoad() {
        view?.startLoader()
        service.fetchTransactions { [weak self] result in
            guard let self = self else { return }
            self.view?.stopLoader()
            switch result {
            case .success(let dtoTransactions):
                transactions = dtoTransactions.compactMap { DefaultMapper().transactionMapper(dto: $0) }
                groupedTransactions = groupTransactions(transactions)
                updateUI()
            case .failure(let error):
                self.view?.showError()
            }
        }
    }
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
private extension ProductModulePresenter {
    func updateUI() {
        guard !groupedTransactions.isEmpty else {
            view?.showEmpty()
            return
        }
        let items: [ProductModuleViewCell.Model] = groupedTransactions.map {
            .init(sku: $0.sku, transactionCount: "\($0.count) transactions >")
        }
        let viewModel = ProductModuleView.Model(items: items)
        view?.update(model: viewModel)
    }
    
    func groupTransactions(_ transactions: [TransactionModel]) -> [OperationModel] {
        let grouped = transactions.reduce(into: [String: Int]()) { result, transaction in
            result[transaction.sku, default: 0] += 1
        }
        let result = grouped.map { OperationModel(sku: $0.key, count: $0.value) }
        return result
    }
}

