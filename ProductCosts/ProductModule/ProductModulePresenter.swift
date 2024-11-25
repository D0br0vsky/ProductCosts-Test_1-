
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
    private var dataStorage: DataStorage
    private var model: [Transaction]?
    private var groupedTransactions: [transactionDictionary] = []
    
    init(service: DataServiceProtocol, router: ProductModuleRouter, dataStorage: DataStorage) {
        self.service = service
        self.router = router
        self.dataStorage = dataStorage
    }
    
    func tapRow(index: Int) {
        guard let model = model, model.indices.contains(index) else { return }
        let selectedTransaction = model[index]
        router.openModuleTransaction(with: selectedTransaction.sku)
    }
    
    func viewDidLoad() {
        if let saveData = DataStorage.dataShared.preparedData as? [Transaction] {
            let readyTransactionGroup = groupTransactions(saveData)
            self.updateUI()
        } else {
            
            view?.startLoader()
            service.fetchTransactions { [weak self] (result: Result<[Transaction], Error>) in
                guard let self else { return }
                self.view?.stopLoader()
                switch result {
                case let .success(dataStorage):
                    DataStorage.dataShared.preparedData = dataStorage
                    let readyTransactionGroup = groupTransactions(dataStorage)
                    self.updateUI()
                case .failure(let error):
                    print("Failed to load transactions: \(error)")
                    self.view?.showError()
                }
            }
        }
    }
    
    
    func updateUI() {
        guard !groupedTransactions.isEmpty else {
            view?.showEmpty()
            return
        }
        let items: [ProductModuleViewCell.Model] = groupedTransactions.map {
            .init(sku: $0.sku, transactionCount: "\($0.count) transactions")
        }
        let viewModel = ProductModuleView.Model(items: items)
        view?.update(model: viewModel)
    }
}


// MARK: - Extension func
extension ProductModulePresenter {
    
    private func groupTransactions(_ transactions: [Transaction]) -> [transactionDictionary] {
        let grouped = transactions.reduce(into: [String: Int]()) { result, transaction in
            result[transaction.sku, default: 0] += 1
        }
        let result = grouped
            .map { transactionDictionary(sku: $0.key, count: $0.value) }
            .sorted { $0.sku < $1.sku }
        return result
    }
}
