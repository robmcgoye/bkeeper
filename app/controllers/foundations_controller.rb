class FoundationsController < ApplicationController
  before_action :set_foundation, only: %i[ edit update destroy ]
  before_action :check_permissions, only: %i[ new create edit update destroy ]
  def index
    @foundations = Foundation.all
  end

  def dashboard
    @foundation = Foundation.find(params[:foundation_id])
    render turbo_stream: [
      turbo_stream.replace("sidebar", partial: "layouts/sidebar", locals: {foundation: @foundation} ),      
      turbo_stream.replace("sidebar-button", partial: "layouts/sidebar_button", locals: { name: @foundation.short_name }),
      turbo_stream.replace("main_content", partial: "foundations/dashboard")
    ]
  end

  def new
    @foundation = Foundation.new
  end

  def edit
    render turbo_stream: [
      turbo_stream.replace("main_content", partial: "foundations/edit_page")
    ]
  end

  def cancel
    render turbo_stream: [
      turbo_stream.replace(Foundation.new, partial: "foundations/create")
    ]    
  end 

  def create
    @foundation = Foundation.new(foundation_params)
      if @foundation.save
        flash.now[:notice] = "Foundation was successfully created."
        @foundations = Foundation.all
        render turbo_stream: [
          turbo_stream.replace("messages", partial: "layouts/messages"), 
          turbo_stream.replace(Foundation.new, partial: "foundations/create"), 
          turbo_stream.replace("foundations-nav-list", partial: "layouts/foundations_list", locals: {foundations: @foundations} ),
          turbo_stream.replace("foundation_list", partial: "foundations/foundation_list")
        ]
      else
        render :new, status: :unprocessable_entity
      end
  end

  def update
    if @foundation.update(foundation_params)
      flash.now[:notice] = "Foundation was successfully updated."
      render turbo_stream: [
        turbo_stream.replace("messages", partial: "layouts/messages"), 
        turbo_stream.replace("sidebar-button", partial: "layouts/sidebar_button", locals: { name: @foundation.short_name }),
        turbo_stream.replace("main_content", partial: "foundations/edit_page")
      ]
    else
      render turbo_stream: [
        turbo_stream.replace("main_content", partial: "foundations/edit_page")
      ]
    end
  end

  def destroy
    @foundation.destroy
    redirect_to root_url, notice: "Foundation was successfully destroyed."
  end

  private
    def set_foundation
      @foundation = Foundation.find(params[:id])
    end

    def check_permissions
      authorize :user, :crud_actions?
    end

    def foundation_params
      params.require(:foundation).permit(:short_name, :long_name)
    end
end
