class UserController < ApplicationController
  skip_before_filter :admin_authorize
  def index
  end

  def userpost
  end

  def team
  	
  end
end
