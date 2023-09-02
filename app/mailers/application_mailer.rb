require 'digest/sha2'
class ApplicationMailer < ActionMailer::Base
  default "Message-ID"=>"#{Digest::SHA2.hexdigest(Time.now.to_i.to_s)}@#{CONFIG[:message_id_domain]}"
  default from: CONFIG[:send_email_from]
  layout "mailer"
end
