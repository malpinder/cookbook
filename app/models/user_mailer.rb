class UserMailer < ActionMailer::Base
  def registration_confirmation(user)
    recipients   user.email
    from         "cookbook@majrekar.com"
    subject      "Thankyou for registering an account with Cookbook."
    body         :user => user
    content_type "text/html"
  end

end
