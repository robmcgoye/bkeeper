class Fdn::Contributions::GrantsController < Fdn::BaseController
  before_action :set_grant, only: %i[ show edit update destroy ]

  def index
    @grants = Grant.organization_grants(@foundation.organization_ids)
    render turbo_stream: [
      turbo_stream.replace("main_content", partial: "index")
    ]  
  end
  
  def cancel
    if params[:id].to_i != -1
      set_grant
      render turbo_stream: [
        params[:show].to_i == 0 ? turbo_stream.replace(@grant, partial: "grant", locals: {grant: @grant}) : turbo_stream.replace(@grant, partial: "show")
      ]
    else
      flash.now[:notice] = "New Grant Wizard canceled."
      render turbo_stream: [
        turbo_stream.replace("messages", partial: "layouts/messages"), 
        turbo_stream.replace(Grant.new, partial: "new_button")
      ]
    end
  end

  def new_next
    if !params[:organization_id].blank?
      @organization = @foundation.organizations.where(id: params[:organization_id].to_i).take
      if @organization.present?
        @grant = @organization.grants.new
        @grant.build_register
      else
        flash.now[:alert] = "Organization selected was not found!!."
        render :cancel
      end
    else
      flash.now[:alert] = "Error with wizard no organization selected!"
      render :cancel
    end
  end

  def show
    render turbo_stream: [
      turbo_stream.replace("grants-main", partial: "show")
    ]      
  end

  def new
    params[:query].blank? ?  @organizations = Organization.none : @organizations = @foundation.organizations.filter_by_name(params[:query]).sort_name_up
  end

  def edit
    @param_show = params[:show].to_i
  end

  def create
    @grant = Grant.new(grant_params)
    if @grant.save
      flash.now[:notice] = "Grant was successfully created."
      render turbo_stream: [
        turbo_stream.replace("messages", partial: "layouts/messages"), 
        turbo_stream.replace(Grant.new, partial: "new_button"), 
        turbo_stream.replace("grant-list", partial: "grant_list", locals: {grants: Grant.organization_grants(@foundation.organization_ids)})
      ]  
    else
      render :new_next, status: :unprocessable_entity
    end
  end

  def update
    if @grant.update(grant_params)
      flash.now[:notice] = "Grant was successfully updated."
      render turbo_stream: [
        turbo_stream.replace("messages", partial: "layouts/messages"), 
        params[:grant][:show] == "1" ? 
        turbo_stream.replace(@grant, partial: "show") : turbo_stream.replace(@grant, partial: "grant", locals: {grant: @grant})
      ]
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @grant.destroy
    @grants = Grant.organization_grants(@foundation.organization_ids)
    flash.now[:notice] = "Grant was successfully destroyed."
    render turbo_stream: [
      turbo_stream.replace("messages", partial: "layouts/messages"), 
      params[:show].to_i == 1 ? 
      turbo_stream.replace("main_content", partial: "index") : turbo_stream.replace("grant-list", partial: "grant_list", locals: {grants: @grants})
    ] 
  end

  private
    def set_grant
      @grant = Grant.find(params[:id])
    end

    def grant_params
      params.require(:grant).permit(:donor_id, :funding_source_id, :organization_id, 
          register_attributes: [ 
            :check_number, :transaction_at, :description, :amount, :bank_account_id
            ])
    end
end
