class ApplicationController < ActionController::Base
  before_filter :authorize
  before_filter :admin_authorize
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  protected
  
  def authorize
    unless User.find_by_id(session[:user_id])
      redirect_to login_url, :notice => "请登录"
    end
  end
  
  def admin_authorize
    unless User.find_by_id(session[:user_id]).admin?
      redirect_to root_path, :notice => "您不是管理员"
    end
  end
  
  private
  
  def current_user
    User.find(session[:user_id])
  end
  
end
