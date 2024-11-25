
protocol TransactionModulePresenterProtocol: AnyObject {
    func viewDidLoad()
}

final class TransactionModulePresenter: TransactionModulePresenterProtocol {
    
    private let sku: String
    private var transactions: [String] = []
    private var total: Double = 0
    weak var view: TransactionModuleControllerProtocol?
    
    init(sku: String) {
        self.sku = sku
    }
    
    func viewDidLoad() {
        transactions = fetchTransactions(for: sku)
        total = calculateTotal(from: transactions)
        view?.update(with: transactions, total: String(format: "£%.2f", total))
    }
    
    private func fetchTransactions(for sku: String) -> [String] {
        return ["£30.20", "£19.70", "£25.80", "£25.90"] 
    }
    
    private func calculateTotal(from transactions: [String]) -> Double {
        return transactions
            .compactMap { Double($0.replacingOccurrences(of: "£", with: "")) }
            .reduce(0, +)
    }
}
