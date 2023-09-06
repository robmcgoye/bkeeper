class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include Navigation
  before_action :set_current_request_details
  before_action :authenticate

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def current_user
    Current.user
  end

  private
    def user_not_authorized
      flash.now[:alert] = "You are not authorized to perform this action."
      goto_dashboard
    end
    
    def authenticate
      if session_record = Session.find_by_id(cookies.signed[:session_token])
        Current.session = session_record
      else
        redirect_to sign_in_path
      end
    end
    
    def set_current_request_details
      Current.user_agent = request.user_agent
      Current.ip_address = request.ip
    end
end
