
protocol TransactionModulePresenterProtocol: AnyObject {
    var tittle: String { get }
    func viewDidLoad()
}

final class TransactionModulePresenter: TransactionModulePresenterProtocol {
    
    let transaction: TransactionModel
    let rate: RateModel
    
    var tittle: String { "\(transaction.sku)" }
    private var dod:[Int] = []
    
    weak var view: TransactionModuleViewProtocol?
    
    init(transaction: TransactionModel, rate: RateModel) {
        self.transaction = transaction
        self.rate = rate
    }
    
    // MARK: - Protocol Methods
    func viewDidLoad() {
        someViewDidLoad()
    }
    
    
    
}

extension TransactionModulePresenter {
    func someViewDidLoad() {
       //some update
    }
}

// MARK: - Extension private
private extension TransactionModulePresenter {
    func updateUI() {
 
    }
    
    func indicatorSymbols(_ transactions: TransactionModel, _ rate: RateModel) -> String {
        
        return "Fun"
    }
    
    func convertGBP() {
        // потом поправить и обновитть модель в Cell amountConvertGBP
    }
}

