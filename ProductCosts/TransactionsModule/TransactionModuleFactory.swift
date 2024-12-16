import UIKit

final class TransactionModuleFactory {
    private let dataStorage: DataStorageProtocol
    
    init(dataStorage: DataStorageProtocol) {
        self.dataStorage = dataStorage
    }
    
    struct Context {
        let operationModel: OperationModel
    }
    
    func make(context: Context) -> UIViewController {
        let dataLoader = DataLoader()
        let service = DataService(loadData: dataLoader)
        let dataRateConvertor = DataRateConvertor()
        let presenter = TransactionModulePresenter(operationModel: context.operationModel, service: service, dataStorage: dataStorage, dataRateConvertor: dataRateConvertor)
        let vc = TransactionModuleController(presenter: presenter)
        presenter.view = vc
        return vc
    }
}
