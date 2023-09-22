class Fdn::Contributions::GrantsController < Fdn::BaseController
  before_action :set_grant, only: %i[ show edit update destroy ]

  def index
    @grants = Grant.all
    render turbo_stream: [
      turbo_stream.replace("main_content", partial: "index")
    ]  
  end

  def cancel
    if params[:id].to_i != -1
      # set_organization
      # render turbo_stream: [
      #   turbo_stream.replace(@organization, partial: "organization", locals: {organization: @organization})
      # ]
    else
      # @grant = Grant.new
      flash.now[:notice] = "New Grant Wizard canceled."
      render turbo_stream: [
        turbo_stream.replace("messages", partial: "layouts/messages"), 
        turbo_stream.replace(Grant.new, partial: "new_button")
      ]
    end
  end

  def new_next
    @organization = @foundation.organizations.where(id: params[:organization_id].to_i).take
    if @organization.present?
      @grant = @organization.grants.new
      @grant.build_register
    else
      flash.now[:alert] = "Organization selected was not found!!."
      render :cancel
    end
    
  end

  def show
  end

  def new
    params[:query].blank? ?  @organizations = Organization.none : @organizations = @foundation.organizations.filter_by_name(params[:query]).sort_name_up
  end

  def edit
  end

  def create
    @grant = Grant.new(grant_params)
    # binding.break
    if @grant.save
      # format.html { redirect_to grant_url(@grant), notice: "Grant was successfully created." }
    else
      render :new_next, status: :unprocessable_entity
    end
  end

  def update
    respond_to do |format|
      if @grant.update(grant_params)
        format.html { redirect_to grant_url(@grant), notice: "Grant was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @grant.destroy

    respond_to do |format|
      format.html { redirect_to grants_url, notice: "Grant was successfully destroyed." }
    end
  end

  private
    def set_grant
      @grant = Grant.find(params[:id])
    end

    def grant_params
      params.require(:grant).permit(:donor_id, :funding_source_id, :organization_id, 
          register_attributes: [ 
            :check_number, :transaction_at, :description, :amount_cents, :bank_account_id
            ])
    end
end
