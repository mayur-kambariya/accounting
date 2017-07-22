class Base
  attr_reader :from_account_id

  def initialize(account_id)
    @from_account_id = account_id
  end

  def bank_account
    @bank_account ||= BankAccount.find(from_account_id)
  end
end