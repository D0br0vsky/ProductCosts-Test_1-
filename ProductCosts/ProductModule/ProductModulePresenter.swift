
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
    private var operationModel: [OperationModel] = []
    
    // MARK: - Init
    init(service: DataServiceProtocol, router: ProductModuleRouter) {
        self.service = service
        self.router = router
    }
    
    
    // MARK: - Protocol Methods
    func viewDidLoad() {
        transactionsLoad()
    }
    
    func tapRow(index: Int) {
        guard operationModel.indices.contains(index) else { return }
        let selectedTransaction = operationModel[index]
        router.openModuleTransaction(with: selectedTransaction)
    }
    
    func transactionsLoad() {
        view?.startLoader()
        service.fetchTransactions { [weak self] result in
            guard let self = self else { return }
            self.view?.stopLoader()
            switch result {
            case .success(let dtoTransactions):
                let mapper = DefaultMapper()
                let preparedTransactionData = dtoTransactions.compactMap { mapper.transactionMapper(dto: $0) }
                addTransactionsToOperation(preparedTransactionData)
                updateUI()
            case .failure(let error):
                self.view?.showError()
            }
        }
    }
}


// MARK: - Extension private
private extension ProductModulePresenter {
    func updateUI() {
        guard !operationModel.isEmpty else {
            view?.showEmpty()
            return
        }
        let items: [ProductModuleViewCell.Model] = operationModel.map { operation in
                .init(sku: operation.sku, transactionCount: "\(operation.count) transactions >")
        }
        let viewModel = ProductModuleView.Model(items: items)
        view?.update(model: viewModel)
    }

    func addTransactionsToOperation(_ newTransactions: [TransactionModel]) {
        for transaction in newTransactions {
            if let index = operationModel.firstIndex(where: { $0.sku == transaction.sku }) {
                operationModel[index].transactionModel.append(transaction)
            } else {
                let transactionsForSKU = newTransactions.filter { $0.sku == transaction.sku }
                
                let gruped = transactionsForSKU.reduce(into: [String: Int]()) { result, transaction in
                    result[transaction.sku, default: 0] += 1
                }
                let result = gruped.map { OperationModel(sku: transaction.sku, count: $0.value, transactionModel: transactionsForSKU) }
                operationModel.append(contentsOf: result)
            }
        }
    }
}

