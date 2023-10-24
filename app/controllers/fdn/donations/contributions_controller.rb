class Fdn::Donations::ContributionsController < Fdn::BaseController
  before_action :set_contribution, only: %i[ show edit update destroy ]

  def index
    @pagy, @contributions = pagy(Contribution.none)
    # @contributions = Contribution.organization_contributions(@foundation.organization_ids)
    render turbo_stream: [
      turbo_stream.replace("main_content", partial: "index")
    ]  
  end
  
  def cancel
    if params[:id].to_i != -1
      set_contribution
      render turbo_stream: [
        params[:show].to_i == 0 ? 
        turbo_stream.replace(@contribution, partial: "contribution", locals: {contribution: @contribution}) : turbo_stream.replace(@contribution, partial: "show")
      ]
    else
      flash.now[:notice] = "New Contribution Wizard canceled."
      render turbo_stream: [
        turbo_stream.replace("messages", partial: "layouts/messages"), 
        turbo_stream.replace(Contribution.new, partial: "new_button")
      ]
    end
  end

  def sort
    contributions = Contribution.organization_contributions(@foundation.organization_ids).open_contributions
    if params[:by].to_i == 1
      if params[:dir].to_i == 2
        @pagy, @contributions = pagy(contributions.sort_check_num_down)
      else
        @pagy, @contributions = pagy(contributions.sort_check_num_up)
      end 
    elsif params[:by].to_i == 2
      if params[:dir].to_i == 2
        @pagy, @contributions = pagy(contributions.sort_amt_down)
      else
        @pagy, @contributions = pagy(contributions.sort_amt_up)
      end 
    elsif params[:by].to_i == 3
      if params[:dir].to_i == 2
        @pagy, @contributions = pagy(contributions.sort_organization_down)
      else
        @pagy, @contributions = pagy(contributions.sort_organization_up)
      end 
    else
      if params[:dir].to_i == 2
        @pagy, @contributions = pagy(contributions.sort_date_down)
      else
        @pagy, @contributions = pagy(contributions.sort_date_up)
      end
    end
    render turbo_stream: [
      turbo_stream.replace("contribution-list", partial: "contribution_list", locals: {contributions: @contributions})
    ] 
  end

  def new_next
    if !params[:organization_id].blank?
      @organization = @foundation.organizations.where(id: params[:organization_id].to_i).take
      if @organization.present?
        @contribution = @organization.contributions.new
        @contribution.build_check
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
      turbo_stream.replace("contributions-main", partial: "show")
    ]      
  end

  def new
    params[:query].blank? ?  @organizations = Organization.none : @organizations = @foundation.organizations.filter_by_name(params[:query]).sort_name_up
  end

  def edit
    @param_show = params[:show].to_i
  end

  def create
    @contribution = Contribution.new(contribution_params)
    if @contribution.save
      @pagy, @contributions = pagy(Contribution.organization_contributions(@foundation.organization_ids).open_contributions.sort_date_up)
      flash.now[:notice] = "Contribution was successfully created."
      render turbo_stream: [
        turbo_stream.replace("messages", partial: "layouts/messages"), 
        turbo_stream.replace(Contribution.new, partial: "new_button"), 
        turbo_stream.replace("contribution-list", partial: "contribution_list", locals: {contributions: @contributions})
      ]  
    else
      render :new_next, status: :unprocessable_entity
    end
  end

  def update
    # binding.break
    if @contribution.update(contribution_params)
      flash.now[:notice] = "Contribution was successfully updated."
      render turbo_stream: [
        turbo_stream.replace("messages", partial: "layouts/messages"), 
        params[:contribution][:show] == "1" ? 
        turbo_stream.replace(@contribution, partial: "show") : turbo_stream.replace(@contribution, partial: "contribution", locals: {contribution: @contribution})
      ]
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @contribution.destroy
      @pagy, @contributions = pagy(Contribution.organization_contributions(@foundation.organization_ids).open_contributions.sort_date_up)
      flash.now[:notice] = "Contribution was successfully destroyed."
      render turbo_stream: [
        turbo_stream.replace("messages", partial: "layouts/messages"), 
        params[:show].to_i == 1 ? 
        turbo_stream.replace("main_content", partial: "index") : turbo_stream.replace("contribution-list", partial: "contribution_list", locals: {contributions: @contributions})
      ] 
    else
      flash.now[:notice] = "Contribution is already cleared cannot be deleted."
      render turbo_stream: [
        turbo_stream.replace("messages", partial: "layouts/messages")
      ]
    end
  end

  private
    def set_contribution
      @contribution = Contribution.find(params[:id])
    end

    def contribution_params
      params.require(:contribution).permit(:donor_id, :funding_source_id, :organization_id, 
        check_attributes: [ 
            :id, :check_number, :transaction_at, :description, :amount, :bank_account_id
            ])
    end
end
