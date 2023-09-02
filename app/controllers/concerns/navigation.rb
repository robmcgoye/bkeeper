module Navigation
  extend ActiveSupport::Concern

  def goto_dashboard
    render turbo_stream: [
      turbo_stream.replace("username", partial: "layouts/username"), 
      turbo_stream.replace("messages", partial: "layouts/messages"), 
      turbo_stream.replace("main_content", partial: "pages/dashboard")
    ]
  end

  def goto_users
    render turbo_stream: [
      turbo_stream.replace("messages", partial: "layouts/messages"),
      turbo_stream.replace("main_content", partial: "users/index")
    ]
  end

  def goto_edit_password
    render turbo_stream: [
      turbo_stream.replace("messages", partial: "layouts/messages"),
      turbo_stream.replace("main_content", partial: "passwords/edit")
    ]
  end

  def goto_edit_email
    render turbo_stream: [
      turbo_stream.replace("messages", partial: "layouts/messages"),
      turbo_stream.replace("main_content", partial: "identity/emails/edit")
    ]
  end

  def goto_sessions
    render turbo_stream: [
      turbo_stream.replace("messages", partial: "layouts/messages"),
      turbo_stream.replace("main_content", partial: "sessions/index")
    ]
  end

end
