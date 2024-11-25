import UIKit

final class ProductModuleFactory {
    struct Context {
        
    }
    
    func make() -> UIViewController {
        let dataLoader = DataLoader()
        let dataStorage = DataStorage()
        let service = DataService(loadData: dataLoader)
        let factory = TransactionModuleFactory()
        let router = ProductModuleRouter(factory: factory) 
        let presenter = ProductModulePresenter(service: service, router: router, dataStorage: dataStorage)
        let vc = ProductModuleController(presenter: presenter)
        router.setRoot(vc)
        presenter.view = vc
        return vc
    }
}
