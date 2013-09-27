class PasswordResetsController < ApplicationController
  skip_before_filter :authorize
  skip_before_filter :admin_authorize

  def new
  end

  def create 
    email=params[:email]
    create_time=Time.now
    @user=User.find_by_email(email)
    @user.update_attributes(:password_reset_sent_at=>create_time)
    token=Digest::SHA2.hexdigest(@user.password_reset_sent_at.to_s+"TeamStyle15ResetPassword")
    if @user
      reset_url="http://duishi.eekexie.org/reset_password/"+token
      UserMailer.password_reset(email,reset_url).deliver
      @user.update_attributes(:password_reset_token=>token)
      redirect_to login_path,:notice=>"您的请求已经发送"
    else
      redirect_to login_path,:notice=>"该邮箱没有被注册"
    end 
  end

end
