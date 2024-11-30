
final class DefaultMapper {
    func transactionMapper(dto: TransactionDTO) -> TransactionModel? {
        guard let amount = Double(dto.amount) else {
            return nil
        }
        return TransactionModel(amount: amount, currency: dto.currency, sku: dto.sku)
    }
    
    func rateMapper(dto: RateDTO) -> RateModel? {
        guard let rate = Double(dto.rate) else {
            return nil
        }
        return RateModel(from: dto.from, rate: rate, to: dto.to)
    }
}
