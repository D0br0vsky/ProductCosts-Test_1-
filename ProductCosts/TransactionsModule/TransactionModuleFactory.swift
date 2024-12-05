import UIKit

final class TransactionModuleFactory {
    struct Context {
        let operationModel: OperationModel
    }
    
    func make(context: Context) -> UIViewController {
        let dataLoader = DataLoader()
        let service = DataService(loadData: dataLoader)
        let presenter = TransactionModulePresenter(operationModel: context.operationModel, service: service)
        let vc = TransactionModuleController(presenter: presenter)
        presenter.view = vc
        return vc
    }
}
