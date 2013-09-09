class ApplicationController < ActionController::Base
  include SessionsHelper

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

  def self.rescue_errors
     rescue_from Exception,                            :with => :render_error
     rescue_from RuntimeError,                         :with => :render_error
     rescue_from ActiveRecord::RecordNotFound,         :with => :render_not_found
     rescue_from ActionController::RoutingError,       :with => :render_not_found
     rescue_from ActionController::UnknownController,  :with => :render_not_found
     #rescue_from ActionController::UnknownAction,      :with => :render_not_found
   end
   rescue_errors unless Rails.env.development?
   
   def render_not_found(exception = nil)
     render :template => "errors/404", :status => 404, :layout => 'public'
   end
   
   def render_error(exception = nil)
     render :template => "errors/500", :status => 500, :layout => 'public'
   end
  
end
