
struct OperationModel {
    var sku: String
    var count: Int
}

struct convertСurrencyModel {
    
}

struct TransactionModel: Decodable {
    let amount: Double
    let currency: String
    let sku: String
}

struct RateModel: Decodable {
    let from: String
    let rate: Double
    let to: String
}
