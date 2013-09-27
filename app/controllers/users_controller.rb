class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_filter :authorize, :only => [:create, :destroy, :new, :delete,:password_reset_authorize,:reset_password]
  skip_before_filter :admin_authorize

  # GET /users
  # GET /users.json
  def index
    if current_user.admin?
      @users = User.paginate(page: params[:page]).order(:name)
    else
      redirect_to root_path, :notice => "您不是管理员"
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @sub = 'admin-userprofile'
    if current_user.id==@user.id
      redirect_to user_index_path
    end
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
    @sub = 'edit'
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
    
    if (@team=Team.find_by_id(@user.team_id))&&(@team.users.count>4)
      redirect_to :back, :notice=>"队伍#{@team.name}人数已满"
      return
    end

    if uploaded_path=@user.upload(params)
      @user.portrait_path=uploaded_path.to_s
    else
      @user.portrait_path=@user.fetch(@user)
    end

  #判断用户类别的的逻辑
    if @user.student_number
      if @user.student_number>=2013000000
        @user.user_type="参赛选手"
      else
        if @user.student_number>=2012000000
          @user.user_type="队式开发组"
        else
          if @user.student_number>=2011000000
            @user.user_type="队式元老"
          end
        end
      end
    end

    @user.email=@user.email.downcase    

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
    if params[:user][:renew_portrait]=="yes"||uploaded_path=@user.upload(params)
      File.delete("#{Rails.root}/public/#{@user.portrait_path}") if File.exist?("#{Rails.root}/public/#{@user.portrait_path}")
      if uploaded_path
        @user.portrait_path=uploaded_path.to_s
      else
        @user.portrait_path=@user.fetch(@user)
      end
    end

    respond_to do |format|
      if @user.update(edit_user_params)
        @user.update_attribute(:email,@user.email.downcase)
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
    File.delete("#{Rails.root}/public/#{@user.portrait_path}") if File.exist?("#{Rails.root}/public/#{@user.portrait_path}")
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def password_reset_authorize
    redirect_to root_path, :notice=>"非法的密码重置请求" unless ((@user=User.find_by_password_reset_token(params[:token]))&&(Digest::SHA2.hexdigest(@user.password_reset_sent_at.to_s+"TeamStyle15ResetPassword")==params[:token])&&((Time.now-@user.password_reset_sent_at)<2*60*60))
  end

  def reset_password
    render_not_found(nil) unless ((@user=User.find_by_password_reset_token(params[:token]))&&(Digest::SHA2.hexdigest(@user.password_reset_sent_at.to_s+"TeamStyle15ResetPassword")==params[:token])&&((Time.now-@user.password_reset_sent_at)<2*60*60))
    if (@password=params[:password])==params[:password_confirmation]
      if @user.update_attributes(:hashed_password=>User.encrypt_password(@password,@user.salt))
        redirect_to login_path, :notice=>"密码修改成功"
        @user.update_attributes(:password_reset_token=>nil)
        return
      else
        redirect_to login_path, :notice=>"未知错误"
        return
      end
    else
      redirect_to login_path,:notice=>"两次输入的密码不匹配"
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :true_name, :student_number, :team_id, :portrait, :password, :password_confirmation)
    end

    def edit_user_params
      (current_user.admin?)?(params.require(:user).permit(:name, :email, :true_name, :student_number, :portrait, :user_type, :password, :password_confirmation,:renew_portrait)):params.require(:user).permit(:name, :email, :true_name, :student_number, :portrait, :password, :password_confirmation,:renew_portrait)
    end

end
