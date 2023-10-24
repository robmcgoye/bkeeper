class Fdn::Accounting::ReconciliationsController < Fdn::BaseController
  before_action :set_bank_account, only: %i[ index new cancel new_next create ]

  def index
    @reconciliations = @bank_account.reconciliations
  end

  def new
    @reconciliation = @bank_account.reconciliations.new
  end

  def cancel
    render turbo_stream: [
      turbo_stream.replace(Reconciliation.new, partial: "reconciliations_list")
    ]
  end

  def new_next
    @reconciliation = @bank_account.reconciliations.new(reconciliation_params)
    if @reconciliation.valid?
      @checks = @bank_account.checks.open_transactions
    else
      render :new, status: :unprocessable_entity
    end
  end

  def create
    @reconciliation = @bank_account.reconciliations.new(reconciliation_params)
    if @reconciliation.save
      @reconciliation.checks << Check.where(id: params[:reconciliation][:check_ids])
      flash.now[:notice] = "Successfully reconciled statement."
        render turbo_stream: [
          turbo_stream.replace("messages", partial: "layouts/messages"),
          turbo_stream.replace(Reconciliation.new, partial: "reconciliations_list")
        ]
    else
      render :new_next, status: :unprocessable_entity
    end
  end

  private

  def set_bank_account
    @bank_account = BankAccount.find(params[:bank_account_id])
  end

  def reconciliation_params
    params.require(:reconciliation).permit( :bank_account_id, :started_at, :ended_at, 
      :starting_balance, :ending_balance, :check_ids => [] )
  end

end