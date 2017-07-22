class BankAccount < ActiveRecord::Base
  has_many :transactions

  def current_balance
    transactions.sum(:amount)
  end
end
