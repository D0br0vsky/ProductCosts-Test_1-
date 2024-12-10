
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
        loadData.fetchData(from: "transactions", as: [TransactionDTO].self, completion: completion)
    }
    
    func fetchRates(completion: @escaping (Result<[RateDTO], Error>) -> Void) {
        loadData.fetchData(from: "rates", as: [RateDTO].self, completion: completion)
    }
}




