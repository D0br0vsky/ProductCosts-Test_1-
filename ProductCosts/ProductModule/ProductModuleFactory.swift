import UIKit

import UIKit

final class ProductModuleFactory {
    
    static func makeWithInitializedRates(completion: @escaping (UIViewController) -> Void) {
        let loadData = DataLoader()
        let service = DataService(loadData: loadData)
        let ratesDataStorage = RatesDataStorage(service: service)
        ratesDataStorage.ratesLoad {
            let vc = ProductModuleFactory.make(ratesDataStorage: ratesDataStorage)
            completion(vc)
        }
    }
    
    static func make(ratesDataStorage: RatesDataStorageProtocol) -> UIViewController {
        let factory = TransactionModuleFactory(ratesDataStorage: ratesDataStorage)
        let dataLoader = DataLoader()
        let router = ProductModuleRouter(factory: factory)
        let service = DataService(loadData: dataLoader)
        let dataStorage = RatesDataStorage(service: service)
        let presenter = ProductModulePresenter(service: service, router: router, dataStorage: dataStorage)
        let vc = ProductModuleController(presenter: presenter)
        router.setRoot(vc)
        presenter.view = vc
        return vc
    }
}
