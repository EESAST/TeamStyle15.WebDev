class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_filter :authorize, :only => [:create, :destroy, :new, :delete]
  skip_before_filter :admin_authorize

  # GET /users
  # GET /users.json
  def index
    if User.find_by_id(session[:user_id]).admin?
      @users = User.order(:name)
    else
      redirect_to root_path, :notice => "您不是管理员"
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    if User.find_by_id(session[:user_id]) && !User.find_by_id(session[:user_id]).admin?
      redirect_to user_index_path, :notice => "您已经登录"
    else
      @user = User.new
    end
  end

  # GET /users/1/edit
  def edit
    if !(current_user=User.find_by_id(session[:user_id]))
      redirect_to login_url, :notice => "无效的请求"
      return 
    end
    if current_user.id!=@user.id && !current_user.admin?
      redirect_to root_path,:notice=>"无效的请求"
      return 
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "用户#{@user.name}注册成功." }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "修改用户#{@user.name}的信息成功." }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if !(current_user=User.find_by_id(session[:user_id]))
      redirect_to login_url, :notice => "无效的请求"
      return 
    end
    if current_user.id!=@user.id && !current_user.admin?
      redirect_to root_path,:notice=>"无效的请求"
      return 
    end
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :hashed_password, :salt, :true_name, :student_number, :team_id, :portait_path, :type, :password, :password_confirmation)
    end
end
