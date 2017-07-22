class Transaction < ActiveRecord::Base
  DEPOSIT = 'Deposit'
  WITHDRAW = 'Withdraw'
  TRANSFER = 'Transfer'

  belongs_to :bank_account

  def credit?
    amount > 0
  end

  def debit?
    amount < 0
  end
end
