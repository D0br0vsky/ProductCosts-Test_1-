
import Foundation

protocol DataServiceProtocol {
    func fetchTransactions(completion: @escaping (Result<[TransactionDTO], Error>) -> Void)
    func fetchRates(completion: @escaping (Result<[RateDTO], Error>) -> Void)
}

final class DataService: DataServiceProtocol {
    private var loadData: DataLoader
    
    init(loadData: DataLoader) {
        self.loadData = loadData
    }
    
    
    func fetchTransactions(completion: @escaping (Result<[TransactionDTO], Error>) -> Void) {
        loadData.fetchData(from: "transactions", as: [TransactionDTO].self) { result in
            switch result {
            case .success(let data):
      //          DataStorage.dataShared.preparedData = data      ->    разобраться с этим дерьмом
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func fetchRates(completion: @escaping (Result<[RateDTO], Error>) -> Void) {
        loadData.fetchData(from: "rates", as: [RateDTO].self, completion: completion)
    }
}




