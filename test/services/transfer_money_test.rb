require 'test_helper'

describe TransferMoney do
  before do
    @mayur_account = bank_accounts(:mayur)
    @surekha_account = bank_accounts(:surekha)
  end

  describe 'existing accounts' do
    it 'adds amount to the balance of target account' do
      existing_balance_of_mayur = @mayur_account.current_balance
      existing_balance_of_surekha = @surekha_account.current_balance

      transferred_amount = TransferMoney.new(@mayur_account.id).call(to_account_id: @surekha_account.id, amount: 10)

      transferred_amount.must_equal 10
      @mayur_account.current_balance.must_equal existing_balance_of_mayur - transferred_amount
      @surekha_account.current_balance.must_equal existing_balance_of_surekha + transferred_amount
    end

    it 'should not transfer amount there is not sufficient balance' do
      lambda do
        TransferMoney.new(@surekha_account.id).call(to_account_id: @mayur_account.id, amount: 10)
      end.must_raise(InsufficientBalanceError)
    end

    it 'should not transfer amount if the amount is negative' do
      lambda { TransferMoney.new(@mayur_account.id).call(to_account_id: @surekha_account.id, amount: -10) }.must_raise(NegativeAmountError)
    end
  end

  describe 'non existing accounts' do
    it 'should not transfer amount if payer account does not exits' do
      lambda { TransferMoney.new(-1).call(to_account_id: @mayur_account.id, amount: 10) }.must_raise(ActiveRecord::RecordNotFound)
    end

    it 'should not transfer amount if payer account does not exits' do
      lambda { TransferMoney.new(@mayur_account.id).call(to_account_id: -1, amount: 10) }.must_raise(ActiveRecord::RecordNotFound)
    end

  end
end