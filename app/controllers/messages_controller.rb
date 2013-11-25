class MessagesController < ApplicationController
  skip_before_filter :admin_authorize, only: [:destroy, :delete, :apply, :invite, :pm]
  before_action :set_message, only: [:destroy,:delete]

  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.all
  end

  def delete
    if @message.read
      redirect_to :back,:notice=>'该消息已读'
    else
      @message.update(:read=>true)
      redirect_to :back,:notice=>'忽略成功'
    end
  end

  def apply
    if current_user.id!=params[:user_id].to_i
      redirect_to :back,notice:"无效的请求"
      return
    end
    @team=Team.find(params[:team_id])
    if @team.full?
      redirect_to :back,notice:"队伍#{@team.name}已经人满"
      return
    end
    @user=User.find(params[:user_id])
    if @user.team_id
      redirect_to :back,notice:"您已经加入了队伍#{Team.find(user.team_id).name}"
      return
    end
    @captain=User.find(@team.captain_id)
    @messages=Message.find(:all,:conditions=>{:messagetype=>3,:content=>@user.id,:user_id=>@captain.id,:read=>false})
    if @messages.count!=0
      redirect_to :back,notice:"您已经发送了相同的入队申请"
      return
    end
    @message=Message.new
    @message.user_id=@captain.id
    @message.messagetype=3
    @message.content=@user.id
    @message.read=false
    @message.save!
    redirect_to :back,:notice=>"入队申请发送成功"
  end
 
  def invite
    @team=Team.find(params[:team_id])
    if current_user.id!=@team.captain_id
      redirect_to :back,notice:"无效的请求"
      return
    end
    if @team.full?
      redirect_to :back,notice:"队伍已满"
      return
    end
    @invited_user=User.find_by_name(@user_str=params[:user_string])
    @invited_user||=User.find_by_true_name(@user_str)
    @invited_user||=User.find_by_student_number(@user_str.to_i)
    @invited_user||=User.find_by_email(@user_str)
    if @invited_user==nil
      redirect_to :back,notice:"查无此人"
      return
    end

    if @invited_user.team_id
      redirect_to :back,notice:"用户#{@invited_user.name}已经加入了队伍#{Team.find(@invited_user.team_id).name}"
      return
    end

    @messages=Message.find(:all,:conditions=>{:messagetype=>4,:content=>@team.id,:user_id=>@invited_user.id,:read=>false})
    if @messages.count!=0
      redirect_to :back,notice:"您已经邀请了这位用户"
      return
    end
    @message=Message.new
    @message.messagetype=4
    @message.user_id=@invited_user.id
    @message.content=@team.id
    @message.read=false
    @message.save!
    redirect_to :back,:notice=>"入队邀请发送成功"
  end

  def pm
    @message=Message.new
    @message.messagetype=6
    @message.user_id=params[:user_id]
    @message.content=params[:content]
    @message.read=false
    @message.text=params[:text]
    if @message.text.empty?
      redirect_to :back, notice: '留言内容不能为空'
      return
    end
    if @message.save!
      redirect_to :back, notice: '留言发送成功'
      return
    else
      redirect_to :back, notice: '留言发送失败'
      return
    end
  end

  def at
    @message=Message.new
    @message.messagetype=5
    @message.user_id=params[:user_id]
    @message.content=params[:content]
    @message.read=false
    if @message.save!
      return
    else
      redirect_to :back, notice: '@失败'
      return
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:user_id, :type, :content, :read, :text)
    end
end
