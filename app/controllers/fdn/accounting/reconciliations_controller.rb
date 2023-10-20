class Fdn::Accounting::ReconciliationsController < Fdn::BaseController
  before_action :set_bank_account, only: %i[ index ]

  def index
  end

  private

  def set_bank_account
    @bank_account = BankAccount.find(params[:bank_account_id])
  end
  
end