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
        let rateModel = [RateModel]()
        let currencyConversionGraph = CurrencyConversionGraph(rates: rateModel)
        let currencyFormatter = CurrencyFormatter()
        let transactionConverter = TransactionConverter(currencyConversionGraph: currencyConversionGraph, currencyFormatter: currencyFormatter)
        let presenter = TransactionModulePresenter(operationModel: context.operationModel, ratesDataStorage: ratesDataStorage, transactionConverter: transactionConverter, currencyConversionGraph: currencyConversionGraph)
        let vc = TransactionModuleController(presenter: presenter)
        presenter.view = vc
        return vc
    }
}
