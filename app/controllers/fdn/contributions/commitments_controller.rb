class Fdn::Contributions::CommitmentsController < Fdn::BaseController
  before_action :set_commitment, only: %i[ show edit update destroy ]

  def index
    @commitments = Commitment.all
    render turbo_stream: [
      turbo_stream.replace("main_content", partial: "index")
    ]      
  end

  def show
  end

  def new
    @commitment = Commitment.new
  end

  def edit
  end

  def create
    @commitment = Commitment.new(commitment_params)

    respond_to do |format|
      if @commitment.save
        format.html { redirect_to commitment_url(@commitment), notice: "Commitment was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @commitment.update(commitment_params)
        format.html { redirect_to commitment_url(@commitment), notice: "Commitment was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @commitment.destroy

    respond_to do |format|
      format.html { redirect_to commitments_url, notice: "Commitment was successfully destroyed." }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_commitment
      @commitment = Commitment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def commitment_params
      params.fetch(:commitment, {})
    end
end
