import UIKit
final class ProductModuleFactory {
    func makeDataLoader() -> DataLoader {
        return DataLoader()
    }

    func makeDataService(dataLoader: DataLoader) -> DataService {
        return DataService(loadData: dataLoader)
    }

    func makeRatesDataStorage(service: DataService) -> RatesDataStorage {
        return RatesDataStorage(service: service)
    }

    func preloadRatesData(progressHandler: @escaping (Float, String) -> Void, completion: @escaping (RatesDataStorageProtocol) -> Void) {
        let dataLoader = makeDataLoader()
        let service = makeDataService(dataLoader: dataLoader)
        let ratesDataStorage = makeRatesDataStorage(service: service)
        
        DispatchQueue.global().async {
            progressHandler(0.13, "Loading Data...")
            Thread.sleep(forTimeInterval: 1)
            
            progressHandler(0.99, "Data processing...")
            Thread.sleep(forTimeInterval: 1)
            
            ratesDataStorage.ratesLoad {
                progressHandler(1.0, "Completing the download!")
                completion(ratesDataStorage)
            }
        }
    }

    func make(ratesDataStorage: RatesDataStorageProtocol) -> UIViewController {
        let factory = TransactionModuleFactory(ratesDataStorage: ratesDataStorage)
        let dataLoader = makeDataLoader()
        let service = makeDataService(dataLoader: dataLoader)
        let router = ProductModuleRouter(factory: factory)
        let presenter = ProductModulePresenter(service: service, router: router, ratesDataStorage: ratesDataStorage)
        let vc = ProductModuleController(presenter: presenter)
        
        router.setRoot(vc)
        presenter.view = vc
        return vc
    }
}
