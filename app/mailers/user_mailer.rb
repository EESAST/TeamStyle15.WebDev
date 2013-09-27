class UserMailer < ActionMailer::Base
  default from: "teamstyle15@126.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(email,url)
    @email=email
    @url=url
    mail(:to=>@email,:subject=>"队式十五网站密码重置")
  end
end
