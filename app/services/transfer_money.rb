class TransferMoney < Base
  def call(to_account_id:, amount:)
    ActiveRecord::Base.transaction do
      WithdrawMoney.new(from_account_id).call(amount: amount)
      DepositMoney.new(to_account_id).call(amount: amount)
    end
    amount
  end
end