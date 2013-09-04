class TeamsController < ApplicationController
  skip_before_filter :admin_authorize
  before_action :set_team, only: [:show, :edit, :update, :destroy]

  # GET /teams
  # GET /teams.json
  def index
    @teams = Team.all
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
  end

  # GET /teams/new
  def new
    if current_user.team_id&&Team.find_by_id(current_user.team_id)
      redirect_to :back, notice: ("您已经加入了队伍\""+Team.find_by_id(current_user.team_id).name+"\"")
      return
    end
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams
  # POST /teams.json
  def create
    @team = Team.new(team_params)
    if !current_user.admin?
      @team.captain_id=current_user.id
      @team.users<<current_user    
      current_user.team_id=@team.id
    end

    respond_to do |format|
      if @team.save
        format.html { redirect_to @team, notice: '创建队伍成功' }
        format.json { render action: 'show', status: :created, location: @team }
      else
        format.html { render action: 'new' }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    if @team.captain_id!=current_user.id&&!current_user.admin?
      redirect_to root_path, notice: '您不是队长'
      return
    end

    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to (current_user.admin?)?(teams_path):(@team), notice: '修改队伍信息成功' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    if @team.captain_id!=current_user.id&&!current_user.admin?
      redirect_to :back, notice: '您不是队长'
      return
    end
    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_url }
      format.json { head :no_content }
    end
  end
  
  def add_member
    @team=Team.find(params[:team_id])
    @user=User.find(params[:user_id])
    if @team.users.count>4 #人数限制
      redirect_to :back,notice:"队伍成员已满"
      return
    end
    if @user.admin?
      redirect_to :back,notice:"管理员不能加入队伍"
      return
    end
    if current_user.id!=@user.id&&!current_user.admin?
      redirect_to :back,notice:"您无权将队员#{@user.name}加入队伍#{@team.name}"
      return
    end
    if @team.users.include?(@user)
      redirect_to :back,alert:"#{(@user==current_user)?"您":(用户+@user.name)}已经加入了队伍#{@team.name}"
      return
    end
    if @user.team_id
      redirect_to :back,alert:"#{(@user==current_user)?"您":(用户+@user.name)}已经加入了队伍#{Team.find(@user.team_id).name}"
      return
    end
    if !@team.captain_id
      @team.update_attribute(:captain_id,@user.id)
    end
    @team.users.push(@user)
    @user.team_id=@team.id
    redirect_to @team,notice:"#{(@user==current_user)?"您":(@user.name)}已成功加入队伍\"#{@team.name}\""
  end
  
  def kick_member
    @team=Team.find(params[:team_id])
    @user=User.find(params[:user_id])
    if @team.captain_id==@user.id
      redirect_to :back,notice:  "您是队长，不能退出队伍"
      return
    elif current_user!=@user.id&&current_user!=@team.captain_id&&!current_user.admin?
      redirect_to :back,notice:"您无权将队员#{@user.name}踢出队伍#{@team.name}"
      return
    elif !@team.users.include?(@user)
      redirect_to :back,alert:"用户#{@user.name}不在队伍#{@team.name}中"
      return
    end
      @team.users.delete(@user)
      redirect_to @team,notice:"#{(@user==current_user)?"您":(@user.name)}已成功退出队伍\"#{@team.name}\""
  end

  private
    # use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    # never trust parameters from the scary internet, only allow the white list through.
    def team_params
      params.require(:team).permit(:name, :captain_id)
    end
end
