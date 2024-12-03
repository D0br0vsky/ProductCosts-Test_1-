import UIKit

final class TransactionModuleFactory {
    
    struct Context {
        let transaction: TransactionModel
        let rate: RateModel
    }
    
    func make(context: Context) -> UIViewController {
        let presenter = TransactionModulePresenter(transaction: context.transaction, rate: context.rate)
        let vc = TransactionModuleController(presenter: presenter)
        presenter.view = vc
        return vc
    }
}

