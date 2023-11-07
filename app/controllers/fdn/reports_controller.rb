class Fdn::ReportsController < Fdn::BaseController

  def dashboard
    render turbo_stream: [
      turbo_stream.replace("main_content", partial: "dashboard")
    ]    
  end

end