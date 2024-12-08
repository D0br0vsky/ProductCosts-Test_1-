
struct OperationModel {
    let sku: String
    let count: Int
    var transactionModel: [TransactionModel]
}

struct TransactionModel: Decodable {
    let amount: Double
    let currency: String
    let sku: String
}

struct СonversionModel {
    let convertGBP: String
    var totalCount: String
    let amountAndCurrency: String
    var rateModel: [RateModel]
}

struct RateModel: Decodable {
    let from: String
    let rate: Double
    let to: String
}

