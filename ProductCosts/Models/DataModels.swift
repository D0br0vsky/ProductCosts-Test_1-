
struct TransactionDTO: Decodable {
    let amount: String // Double
    let currency: String
    let sku: String
}

struct RateDTO: Decodable {
    let from: String
    let rate: String // Double
    let to: String
}
