class Settings::BankAccountsController < Settings::BaseController
  before_action :set_bank_account, only: %i[ edit update destroy ]

  def index
    render turbo_stream: [
      turbo_stream.replace("main_content", partial: "settings/bank_accounts/index")
    ]  
  end

  def new
    @bank_account = BankAccount.new
  end

  def edit
  end

  def create
    @bank_account = @foundation.bank_accounts.new(bank_account_params)
    if @bank_account.save
      flash.now[:notice] = "Bank account was successfully created."
      render turbo_stream: [ 
        turbo_stream.prepend("bank_accounts", @bank_account),
        turbo_stream.replace("form_bank_account",
          partial: "settings/bank_accounts/form", 
          locals: { bank_account: BankAccount.new, form_url: foundation_settings_bank_accounts_path(@foundation)} ),
        turbo_stream.replace("messages", partial: "layouts/messages")
      ]
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @bank_account.update(bank_account_params)
      flash.now[:notice] = "Bank account was successfully updated."
      render turbo_stream: [
        turbo_stream.replace(@bank_account, @bank_account),
        turbo_stream.replace("messages", partial: "layouts/messages")
      ]   
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @bank_account.destroy
    flash.now[:notice] = "Bank account was successfully deleted."
    render turbo_stream: [
      turbo_stream.remove(@bank_account),
      turbo_stream.replace("messages", partial: "layouts/messages")
    ]
  end

  private

    def set_bank_account
      @bank_account = BankAccount.find(params[:id])
    end

    def bank_account_params
      params.require(:bank_account).permit(:full_name, :primary)
      # , :starting_balance
    end
end
