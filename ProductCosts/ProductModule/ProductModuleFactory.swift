import UIKit

final class ProductModuleFactory {
    private let dataStorage: DataStorageProtocol
    
    init(dataStorage: DataStorageProtocol) {
        self.dataStorage = dataStorage
    }
    
    struct Context {
        
    }
    
    func make() -> UIViewController {
        let factory = TransactionModuleFactory(dataStorage: dataStorage)
        let dataLoader = DataLoader()
        let router = ProductModuleRouter(factory: factory)
        let service = DataService(loadData: dataLoader)
        let dataStorage = DataStorage(service: service)
        let presenter = ProductModulePresenter(service: service, router: router, dataStorage: dataStorage)
        let vc = ProductModuleController(presenter: presenter)
        router.setRoot(vc)
        presenter.view = vc
        return vc
    }
}
