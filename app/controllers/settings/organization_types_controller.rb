class Settings::OrganizationTypesController < Settings::BaseController
  before_action :set_organization_type, only: %i[ edit update destroy ]

  def index
    render turbo_stream: [
      turbo_stream.replace("main_content", partial: "settings/organization_types/index")
    ]
  end

  def new
    @organization_type = OrganizationType.new
  end

  def edit
  end

  def create
    @organization_type = @foundation.organization_types.new(organization_type_params)
    if @organization_type.save
      flash.now[:notice] = "Organization type was successfully created."
      render turbo_stream: [ 
        turbo_stream.prepend("organization_types", @organization_type),
        turbo_stream.replace("form_organization_type",
          partial: "settings/organization_types/form", 
          locals: { organization_type: OrganizationType.new, form_url: new_foundation_settings_organization_type_path(@foundation)} ),
        turbo_stream.replace("messages", partial: "layouts/messages")
      ]
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @organization_type.update(organization_type_params)
      flash.now[:notice] = "Organization type was successfully updated."
      render turbo_stream: [
        turbo_stream.replace(@organization_type, @organization_type),
        turbo_stream.replace("messages", partial: "layouts/messages")
      ]
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @organization_type.destroy
    flash.now[:notice] = "Organization type was successfully deleted."
    render turbo_stream: [
      turbo_stream.remove(@organization_type),
      turbo_stream.replace("messages", partial: "layouts/messages")
    ]
  end

  private

    def set_organization_type
      @organization_type = OrganizationType.find(params[:id])
    end

    def organization_type_params
      params.require(:organization_type).permit(:code, :description)
    end

end
