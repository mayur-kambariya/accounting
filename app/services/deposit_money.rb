class DepositMoney < Base
  def call(amount:)
    raise NegativeAmountError if amount <= 0

    bank_account.transactions.create(amount: amount)
    amount
  end
end