class AdminController < ApplicationController
  before_filter :admin_authorize
  
  def index
  end
  
  protected

  def admin_authorize
    unless User.find_by_id(session[:user_id]).admin?
      redirect_to root_path, :notice => "只有管理员能够访问"
    end
  end
  
end
