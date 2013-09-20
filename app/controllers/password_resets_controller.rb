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

  def authorize
    redirect_to root_path, :notice=>"非法的密码重置请求" unless ((@user=User.find_by_password_reset_token(params[:token]))&&(Digest::SHA2.hexdigest(@user.password_reset_sent_at.to_s+"TeamStyle15ResetPassword")==params[:token]))#&&((Time.now-@user.password_reset_sent_at)<2*60*60))
  end

  def reset 
    redirect_to root_path, :notice=>"非法的密码重置请求" unless ((@user=User.find_by_password_reset_token(params[:token]))&&(Digest::SHA2.hexdigest(@user.password_reset_sent_at.to_s+"TeamStyle15ResetPassword")==params[:token]))#&&((Time.now-@user.password_reset_sent_at)<2*60*60))
    #if (@password=params[:password])==params[:password_confirmation]
      respond_to do |format|
        if @user.update(password_reset_params)
          format.html { redirect_to @user, notice: "修改用户#{@user.name}的信息成功." }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
      #if @user.update_attributes(:hashed_password=>User.encrypt_password(@password,@user.salt))
       # redirect_to login_path, :notice=>"密码修改成功"
       # return
      #else
      #  redirect_to root_path, :notice=>"未知错误"
      #  return
      #end
    #else
     # redirect_to root_path,:notice=>"两次输入的密码不匹配"
    #end
  end

  def password_reset_params
    params.require(:password_reset).permit(:password, :password_confirmation)
  end

end
