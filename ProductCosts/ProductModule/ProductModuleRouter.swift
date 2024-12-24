
import UIKit

protocol ProductModuleRouterProtocol: AnyObject {
    func openModuleTransaction(with operationModel: OperationModel)
}

final class ProductModuleRouter: ProductModuleRouterProtocol {
    private let factory: TransactionModuleFactory
    private weak var root: UIViewController?

    init(factory: TransactionModuleFactory) {
        self.factory = factory
    }

    func setRoot(_ root: UIViewController) {
        self.root = root
    }

    func openModuleTransaction(with operationModel: OperationModel) {
        let context = TransactionModuleFactory.Context(operationModel: operationModel)
        let viewController = factory.make(context: context)
        root?.navigationController?.pushViewController(viewController, animated: true)
    }
}
