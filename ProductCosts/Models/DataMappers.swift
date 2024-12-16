
final class DefaultMapper {
    func transactionConverter(dto: TransactionDTO) -> TransactionModel? {
        guard let amount = Double(dto.amount) else {
            return nil
        }
        return TransactionModel(sku: dto.sku, amount: amount, currency: dto.currency)
    }
    
    func rateConverter(dto: RateDTO) -> RateModel? {
        guard let rate = Double(dto.rate) else {
            return nil
        }
        return RateModel(from: dto.from, rate: rate, to: dto.to)
    }
}
