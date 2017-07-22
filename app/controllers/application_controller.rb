require 'exceptions'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ::InsufficientBalanceError, with: :insufficient_balance
  rescue_from ::NegativeAmountError, with: :invalid_amount
  skip_before_action :verify_authenticity_token

  private

  def not_found
    response_json = return_response.merge!({
      success: false,
      message: "The resource you are looking for does not exists",
    })
    render json: response_json
  end

  def insufficient_balance
    response_json = return_response.merge!({
      success: false,
      message: 'There is not enough balance in your account',
    })
    render json: response_json
  end

  def invalid_amount
    response_json = return_response.merge!({
      success: false,
      message: 'Please enter valid amount'
    })
    render json: response_json
  end

  def return_response
    {
      current_balance: @current_account.current_balance,
      users: BankAccount.all.as_json,
      current_account: @current_account.as_json,
      account_details: @current_account.transactions.as_json
    }
  end
end
