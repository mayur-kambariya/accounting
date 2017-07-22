class WithdrawMoney < Base
  def call(amount:)
    raise NegativeAmountError if amount <= 0

    raise InsufficientBalanceError if bank_account.current_balance < amount

    bank_account.transactions.create(amount: -amount)
    amount
  end
end