import UIKit

final class ProductModuleFactory {
    struct Context {
        
    }
    
    func make() -> UIViewController {
        
        let factory = TransactionModuleFactory()
        let dataLoader = DataLoader()
        let service = DataService(loadData: dataLoader)
        let router = ProductModuleRouter(factory: factory) 
        let presenter = ProductModulePresenter(service: service, router: router)
        let vc = ProductModuleController(presenter: presenter)
        router.setRoot(vc)
        presenter.view = vc
        return vc
    }
}

