
struct Transaction: Decodable {
    let amount: String
    let currency: String
    let sku: String
}

struct Rate: Decodable {
    let from: String
    let rate: String
    let to: String
}
