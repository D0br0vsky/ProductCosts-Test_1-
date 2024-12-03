import UIKit

final class TransactionModuleFactory {
    struct Context {
        let transaction: TransactionModel
    }
    
    func make(context: Context) -> UIViewController {
        let dataLoader = DataLoader()
        let service = DataService(loadData: dataLoader)
        let presenter = TransactionModulePresenter(transaction: context.transaction, service: service)
        let vc = TransactionModuleController(presenter: presenter)
        presenter.view = vc
        return vc
    }
}
