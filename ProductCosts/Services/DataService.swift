
import Foundation

protocol DataServiceProtocol {
    func fetchTransactions(completion: @escaping (Result<[Transaction], Error>) -> Void)
    func fetchRates(completion: @escaping (Result<[Rate], Error>) -> Void)
}

final class DataService: DataServiceProtocol {
    private var loadData: DataLoader
    
    init(loadData: DataLoader) {
        self.loadData = loadData
    }
    
    
    func fetchTransactions(completion: @escaping (Result<[Transaction], Error>) -> Void) {
        loadData.fetchData(from: "transactions", as: [Transaction].self) { result in
            switch result {
            case .success(let data):
                DataStorage.dataShared.preparedData = data
                print("data saved successfully ")
            case .failure(let error):
                print("data not saved")
            }
        }
    }
    
    
    func fetchRates(completion: @escaping (Result<[Rate], Error>) -> Void) {
        loadData.fetchData(from: "rates", as: [Rate].self, completion: completion)
    }
}





