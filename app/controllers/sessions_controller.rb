class SessionsController < ApplicationController
  skip_before_filter :authorize
  skip_before_filter :admin_authorize
  def new
    if User.find_by_id(session[:user_id])
      redirect_to user_index_path, :notice => '您已经登录'
    end
  end

  def create      
    if user = User.authenticate(params[:name], params[:password])
      session[:user_id] = user.id
      if admin?(user)
        redirect_to admin_url
      else
        redirect_to user_index_path
      end
    else
      redirect_to login_url, :alert => "用户名或密码错误"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, :notice => "已经退出登录"
  end
  
  private
  
  def admin?(user)
    user.admin?
  end
end
