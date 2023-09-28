class Fdn::Contributions::CommitmentsController < Fdn::BaseController
  before_action :set_commitment, only: %i[ show edit update destroy ]

  def index
    @commitments = Commitment.organization_commitments(@foundation.organization_ids)
    render turbo_stream: [
      turbo_stream.replace("main_content", partial: "index")
    ]      
  end

  def cancel
    if params[:id].to_i != -1
      set_commitment
      render turbo_stream: [
        params[:show].to_i == 0 ? turbo_stream.replace(@commitment, partial: "commitment", locals: {commitment: @commitment}) : turbo_stream.replace(@commitment, partial: "show")
      ]
    else
      flash.now[:notice] = "New Commitment Wizard canceled."
      render turbo_stream: [
        turbo_stream.replace("messages", partial: "layouts/messages"), 
        turbo_stream.replace(Commitment.new, partial: "new_placeholder")
      ]
    end
  end

  def new_next
    if !params[:organization_id].blank?
      @organization = @foundation.organizations.where(id: params[:organization_id].to_i).take
      if @organization.present?
        @commitment = @organization.commitments.new
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
      turbo_stream.replace("commitments-main", partial: "show")
    ] 
  end

  def new
    params[:query].blank? ?  @organizations = Organization.none : @organizations = @foundation.organizations.filter_by_name(params[:query]).sort_name_up
  end

  def edit
    @param_show = params[:show].to_i
  end

  def create
    @commitment = Commitment.new(commitment_params)
    if @commitment.save
      flash.now[:notice] = "Commitment was successfully created."
      render turbo_stream: [
        turbo_stream.replace("messages", partial: "layouts/messages"), 
        turbo_stream.replace(Commitment.new, partial: "new_placeholder"), 
        turbo_stream.replace("commitment-list", partial: "commitment_list", locals: {commitments: Commitment.organization_commitments(@foundation.organization_ids)})
      ]        
    else
      render :new_next, status: :unprocessable_entity
    end
  end

  def update
    if @commitment.update(commitment_params)
      flash.now[:notice] = "Commitment was successfully updated."
      render turbo_stream: [
        turbo_stream.replace("messages", partial: "layouts/messages"), 
        params[:grant][:show] == "1" ? 
        turbo_stream.replace(@commitment, partial: "show") : turbo_stream.replace(@commitment, partial: "commitment", locals: {commitment: @commitment})
      ]
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @commitment.destroy
    @commitments = Commitment.organization_commitments(@foundation.organization_ids)
    flash.now[:notice] = "Commitment was successfully destroyed."
    render turbo_stream: [
      turbo_stream.replace("messages", partial: "layouts/messages"), 
      params[:show].to_i == 1 ? 
      turbo_stream.replace("main_content", partial: "index") : turbo_stream.replace("commitment-list", partial: "commitment_list", locals: {commitments: @commitments})
    ] 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_commitment
      @commitment = Commitment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def commitment_params
      params.require(:commitment).permit( :organization_id, :start_at, :end_at, 
        :number_payments, :amount, :code )
    end
end
