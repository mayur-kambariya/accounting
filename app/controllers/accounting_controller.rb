require 'exceptions'

class AccountingController < ApplicationController
  before_filter :set_current_account

  def dashboard
    respond_to do |format|
      format.html
      format.json
    end
  end

  def get_dashboard
    render json: return_response.merge!({ success: true })
  end

  def deposit
    amount_val = transaction_params['amount'].to_i
    @current_account =  BankAccount.find(transaction_params['from_account_id'])
    DepositMoney.new(transaction_params['from_account_id']).call(amount: amount_val)
    render json: return_response.merge!({ success: true })
  end

  def withdraw
    amount_val = transaction_params['amount'].to_i
    @current_account=  BankAccount.find(transaction_params['from_account_id'])
    WithdrawMoney.new(transaction_params['from_account_id']).call(amount: amount_val)
    render json: return_response.merge!({ success: true })
  end

  def transfer
    amount_val = transaction_params['amount'].to_i
    @current_account=  BankAccount.find(transaction_params['from_account_id'])
    TransferMoney.new(transaction_params['from_account_id']).call(to_account_id: transaction_params['to_account_id'], amount: amount_val)
    render json: return_response.merge!({ success: true })
  end

  private

  def set_current_account
    from_account_id = params[:from_account_id].presence || session[:from_account_id].presence
    @current_account =
      if from_account_id
        BankAccount.find(from_account_id)
      else
        BankAccount.first
      end
    session[:from_account_id] = @current_account.id
  end

  def transaction_params
    params.permit(:from_account_id, :to_account_id, :amount)
  end

  def amount
    @amount ||= transaction_params['amount'].to_i
  end
end
