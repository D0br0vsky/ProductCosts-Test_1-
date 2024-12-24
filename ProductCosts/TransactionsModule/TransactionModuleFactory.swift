import UIKit

final class TransactionModuleFactory {
    private let ratesDataStorage: RatesDataStorageProtocol
    
    init(ratesDataStorage: RatesDataStorageProtocol) {
        self.ratesDataStorage = ratesDataStorage
    }
    
    struct Context {
        let operationModel: OperationModel
    }
    
    func make(context: Context) -> UIViewController {
        let dataLoader = DataLoader()
        let service = DataService(loadData: dataLoader)
        let currencyFormatter = CurrencyFormatter()
        let presenter = TransactionModulePresenter(operationModel: context.operationModel, service: service, ratesDataStorage: ratesDataStorage, currencyFormatter: currencyFormatter)
        let vc = TransactionModuleController(presenter: presenter)
        presenter.view = vc
        return vc
    }
}
