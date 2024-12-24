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
        let currencyConversionGraph = CurrencyConversionGraph()
        let currencyFormatter = CurrencyFormatter()
        let transactionConverter = TransactionConverter(currencyConversionGraph: currencyConversionGraph, currencyFormatter: currencyFormatter)
        let presenter = TransactionModulePresenter(operationModel: context.operationModel, service: service, ratesDataStorage: ratesDataStorage, transactionConverter: transactionConverter)
        let vc = TransactionModuleController(presenter: presenter)
        presenter.view = vc
        return vc
    }
}
