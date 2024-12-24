import UIKit

final class ProductModuleFactory {
    private static func makeDataLoader() -> DataLoader {
        return DataLoader()
    }

    private static func makeDataService(dataLoader: DataLoader) -> DataService {
        return DataService(loadData: dataLoader)
    }

    private static func makeRatesDataStorage(service: DataService) -> RatesDataStorage {
        return RatesDataStorage(service: service)
    }

    static func makeWithInitializedRates(completion: @escaping (UIViewController) -> Void) {
        let dataLoader = makeDataLoader()
        let service = makeDataService(dataLoader: dataLoader)
        let ratesDataStorage = makeRatesDataStorage(service: service)
        
        ratesDataStorage.ratesLoad {
            let vc = ProductModuleFactory.make(ratesDataStorage: ratesDataStorage)
            completion(vc)
        }
    }

    static func make(ratesDataStorage: RatesDataStorageProtocol) -> UIViewController {
        let factory = TransactionModuleFactory(ratesDataStorage: ratesDataStorage)
        let dataLoader = makeDataLoader()
        let service = makeDataService(dataLoader: dataLoader)
        let ratesDataStorage = makeRatesDataStorage(service: service)
        
        let router = ProductModuleRouter(factory: factory)
        let presenter = ProductModulePresenter(service: service, router: router, ratesDataStorage: ratesDataStorage)
        let vc = ProductModuleController(presenter: presenter)
        
        router.setRoot(vc)
        presenter.view = vc
        return vc
    }
}
