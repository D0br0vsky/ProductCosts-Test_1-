
import Foundation

protocol DataStorageProtocol {
    func getRates() -> [RateModel]
    func setRates(_ cachedData: [RateModel])
    func ratesLoad(completion: @escaping () -> Void)
}

final class DataStorage: DataStorageProtocol {
    private let service: DataServiceProtocol
    private var cachedData: [RateModel] = []
    
    init(service: DataServiceProtocol) {
        self.service = service
    }
    
    func setRates(_ cachedData: [RateModel]) {
        self.cachedData = cachedData
    }
    
    func getRates() -> [RateModel] {
        return cachedData
    }
    
    func ratesLoad(completion: @escaping () -> Void) {
        service.fetchRates { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let dtoRates):
                    let ratesConvertValues = dtoRates.compactMap { DefaultMapper().rateConverter(dto: $0) }
                    self.cachedData = ratesConvertValues
                    completion()
                case .failure:
                    completion()
                }
            }
        }
    }
}
