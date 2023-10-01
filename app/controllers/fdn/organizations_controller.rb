class Fdn::OrganizationsController < Fdn::BaseController
  before_action :set_organization, only: %i[ show edit update destroy ]

  def index
    @pagy, @organizations = pagy(@foundation.organizations.sort_name_up)
    render turbo_stream: [
      turbo_stream.replace("main_content", partial: "index")
    ]  
  end

  def filter
    if params[:query].blank?
      @pagy, @organizations = pagy(@foundation.organizations.sort_name_up) 
    else
      @pagy, @organizations = pagy(@foundation.organizations.filter_by_name(params[:query]).sort_name_up)
    end
    render turbo_stream: [
      turbo_stream.replace("organizations_list", partial: "organizations_list", locals: {organizations: @organizations})
    ] 
  end

  def sort
    if params[:query].blank?
      orgs = @foundation.organizations
    else
      orgs = @foundation.organizations.filter_by_name(params[:query])
    end
    
    if params[:by].to_i == 2
      if params[:dir].to_i == 2
        @pagy, @organizations = pagy(orgs.sort_contact_down)
      else
        @pagy, @organizations = pagy(orgs.sort_contact_up)
      end 
    elsif params[:by].to_i == 3
      if params[:dir].to_i == 2
        @pagy, @organizations = pagy(orgs.sort_type_down)
      else
        @pagy, @organizations = pagy(orgs.sort_type_up)
      end 
    else
      if params[:dir].to_i == 2
        @pagy, @organizations = pagy(orgs.sort_name_down)
      else
        @pagy, @organizations = pagy(orgs.sort_name_up)
      end
    end
    render turbo_stream: [
      turbo_stream.replace("organizations_list", partial: "organizations_list", locals: {organizations: @organizations})
    ] 
  end

  def cancel
    if params[:id].to_i == -1
      render turbo_stream: [
        turbo_stream.replace(Organization.new, partial: "search")
      ]
    else
      set_organization
      render turbo_stream: [
        turbo_stream.replace(@organization, partial: "organization", locals: {organization: @organization})
      ]
    end
  end

  def show
    render turbo_stream: [
      turbo_stream.replace("main_content", partial: "show")
    ]      
  end

  def new
    @organization = Organization.new
  end

  def edit
  end

  def create
    @organization = @foundation.organizations.new(organization_params)
    if @organization.save
      # @organizations = @foundation.organizations.sort_name_up
      flash.now[:notice] = "Organization was successfully created."
      render turbo_stream: [
        turbo_stream.replace("messages", partial: "layouts/messages"), 
        turbo_stream.replace(Organization.new, partial: "search"), 
        turbo_stream.replace("organizations_list", partial: "organizations_list", locals: {organizations: @foundation.organizations.sort_name_up})
      ]      
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @organization.update(organization_params)
      flash.now[:notice] = "Organization was successfully updated."
      render turbo_stream: [
        turbo_stream.replace("messages", partial: "layouts/messages"), 
        turbo_stream.replace(@organization, partial: "organization", locals: {organization: @organization})
      ]
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @organization.destroy
    flash.now[:notice] = "Organization was successfully deleted."
    render turbo_stream: [
      turbo_stream.replace("messages", partial: "layouts/messages"), 
      turbo_stream.replace("organizations_list", partial: "organizations_list", locals: {organizations: @foundation.organizations.sort_name_up})
    ]   
  end

  private

    def set_organization
      @organization = Organization.find(params[:id])
    end

    def organization_params
      params.require(:organization).permit(:name, :tax_number, :contact, :address_1, 
        :address_2, :city, :state, :zip, :country, :organization_type_id)
    end

end
