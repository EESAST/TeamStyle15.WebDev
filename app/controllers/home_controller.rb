class HomeController < ApplicationController
  skip_before_filter :authorize
  skip_before_filter :admin_authorize
  def index
  end
end
