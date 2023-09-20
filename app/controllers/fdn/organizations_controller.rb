class Fdn::OrganizationsController < Fdn::BaseController
  before_action :set_organization, only: %i[ show edit update destroy ]

  def index
    @organizations = @foundation.organizations.sort_name_up
    render turbo_stream: [
      turbo_stream.replace("main_content", partial: "index")
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
