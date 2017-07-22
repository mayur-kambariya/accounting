module AccountingHelper
  def bank_account_options
    options_from_collection_for_select(other_bank_accounts, 'id', 'username')
  end

  def other_bank_accounts
    @other_bank_accounts ||= BankAccount.select(:id, :username).where.not(id: @current_account.id)
  end
end
