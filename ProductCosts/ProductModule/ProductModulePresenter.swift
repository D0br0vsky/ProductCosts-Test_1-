import Dispatch

protocol ProductModulePresenterProtocol {
    var title: String { get }
    func tapRow(index: Int)
    func viewDidLoad()
}

final class ProductModulePresenter: ProductModulePresenterProtocol {
    var title: String { "Product" }
    weak var view: ProductModuleViewProtocol?
    private let service: DataServiceProtocol
    private let router: ProductModuleRouter
    private let ratesDataStorage: RatesDataStorageProtocol
    private var operationModel: [OperationModel] = []
    
    init(service: DataServiceProtocol, router: ProductModuleRouter, ratesDataStorage: RatesDataStorageProtocol) {
        self.service = service
        self.router = router
        self.ratesDataStorage = ratesDataStorage
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
        let dispatchGroup = DispatchGroup()
        view?.startLoader()
        
        dispatchGroup.enter()
        var transactions: [TransactionModel] = []
        
        service.fetchTransactions { [weak self] result in
            dispatchGroup.leave()
            switch result {
            case .success(let dtoTransactions):
                let mapper = DefaultMapper()
                transactions = dtoTransactions.compactMap { mapper.transactionConverter(dto: $0) }
            case .failure(_):
                self?.view?.showError()
            }
        }
        
        dispatchGroup.enter()
        ratesDataStorage.ratesLoad { [weak self] in
            guard let self = self else { return }
            _ = ratesDataStorage.getRates()
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            view?.stopLoader()
            
            if transactions.isEmpty {
                view?.showEmpty()
                return
            }
            
            operationModel = createTransactionsToOperation(transactions)
            updateUI()
        }
    }
}

// MARK: - Private Helpers
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
    
    func createTransactionsToOperation(_ newTransactions: [TransactionModel]) -> [OperationModel] {
        var result = [OperationModel]()
        var transactionsBySKU: [String: [TransactionModel]] = [:]
        for transaction in newTransactions {
            transactionsBySKU[transaction.sku, default: []].append(transaction)
        }
        
        for (sku, transactions) in transactionsBySKU {
            let item = OperationModel(sku: sku, transactionModel: transactions)
            result.append(item)
        }
        return result
    }
}
