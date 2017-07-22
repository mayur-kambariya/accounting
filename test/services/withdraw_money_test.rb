require 'test_helper'

describe WithdrawMoney do
  before { @mayur_account = bank_accounts(:mayur) }

  it 'adds amount to the balance' do
    existing_balance = @mayur_account.current_balance

    withdrawn_amount = WithdrawMoney.new(@mayur_account.id).call(amount: 10)
    balance_after_deposit = existing_balance - withdrawn_amount

    withdrawn_amount.must_equal 10
    @mayur_account.current_balance.must_equal balance_after_deposit
  end

  it 'should not withdraw amount there is not sufficient balance' do
    surekha_account = bank_accounts(:surekha)

    lambda { WithdrawMoney.new(surekha_account.id).call(amount: 10) }.must_raise(InsufficientBalanceError)
  end

  it 'should not withdraw amount if the amount is negative' do
    lambda { WithdrawMoney.new(@mayur_account.id).call(amount: -100) }.must_raise(NegativeAmountError)
  end

end