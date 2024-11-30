
struct TransactionDTO: Decodable {
    let amount: String
    let currency: String
    let sku: String
}

struct RateDTO: Decodable {
    let from: String
    let rate: String
    let to: String
}


