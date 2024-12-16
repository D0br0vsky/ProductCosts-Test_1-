
struct OperationModel {
    let sku: String
    var transactionModel: [TransactionModel]
}

struct TransactionModel: Decodable {
    let sku: String
    let amount: Double
    let currency: String
}

struct СonversionModel {
    let convertGBP: String
    var totalCount: String
    let amountAndCurrency: String
}

struct RateModel: Decodable {
    let from: String
    let rate: Double
    let to: String
}

