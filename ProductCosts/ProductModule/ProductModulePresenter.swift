
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
    
    
    private var dataStorage: DataStorageProtocol
    
    
    init(service: DataServiceProtocol, router: ProductModuleRouter, dataStorage: DataStorageProtocol) {
        self.service = service
        self.router = router
        self.dataStorage = dataStorage
    }
    
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
                let preparedTransactionData = dtoTransactions.compactMap { mapper.transactionConverter(dto: $0) }
                addTransactionsToOperation(preparedTransactionData)
                updateUI()
            case .failure(_):
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
                .init(sku: operation.sku, transactionCount: "\(operation.transactionModel.count) transactions >")
        }
        let viewModel = ProductModuleView.Model(items: items)
        view?.update(model: viewModel)
    }
    
    func addTransactionsToOperation(_ newTransactions: [TransactionModel]) {
        var transactionsBySKU: [String: [TransactionModel]] = [:]
        for transaction in newTransactions {
            transactionsBySKU[transaction.sku, default: []].append(transaction)
        }
        
        for (sku, transactions) in transactionsBySKU {
            let item = OperationModel(sku: sku, transactionModel: transactions)
            operationModel.append(item)
        }
    }
}
