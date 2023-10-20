class Fdn::BaseController < ApplicationController
  before_action :set_foundation

  private
  
  def set_foundation
    @foundation = Foundation.find(params[:foundation_id]) if params[:foundation_id].present?
  end

end