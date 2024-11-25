import UIKit

final class TransactionModuleFactory {
    
    struct Context {
        let sku: String
    }
    
    func make(context: Context) -> UIViewController {
        let presenter = TransactionModulePresenter(sku: context.sku)
        let view = TransactionModuleController(presenter: presenter)
        presenter.view = view
        return view
    }
    
}

