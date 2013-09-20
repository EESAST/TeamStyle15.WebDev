# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
TeamStyle15Webdev::Application.initialize!

TeamStyle15Webdev::Application.configure do
  config.action_mailer.delivery_method = :smtp

  config.action_mailer.smtp_settings = {
    :address        => "smtp.126.com",
    :port           => 25,
    :domain         => "mail.126.com",
    :authentication => "login",
    :user_name      => "teamstyle15@126.com",
    :password       => "TeamStyle15.Web",
    :enable_starttls_auto => false,
  }
end
