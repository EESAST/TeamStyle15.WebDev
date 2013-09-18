class UserController < ApplicationController
  skip_before_filter :admin_authorize
  def index
    @sub = "profile"
  end

  def userpost
    @sub = "userpost"
  end

  def team
  	@sub = "team"
  end

  def usermessage
  	@sub = "usermessage"
  end
end
