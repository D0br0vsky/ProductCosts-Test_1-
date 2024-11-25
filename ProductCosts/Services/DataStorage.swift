
import Foundation

final class DataStorage {
    static let dataShared = DataStorage()
    init() {}
    
    var preparedData: [Transaction] = []
}


