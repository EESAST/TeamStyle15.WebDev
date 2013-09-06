class PostsController < ApplicationController
  skip_before_filter :admin_authorize
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.paginate(page: params[:page], :per_page => 15, :order => 'updated_at DESC' )
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    if !current_user
      redirect_to login_url, :notice => "无效的请求"
      return 
    end
    
    if current_user.id != @post.user_id && !current_user.admin?
      redirect_to root_path,:notice=>"无效的请求"
      return
    end
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.user_id=current_user.id

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: '发表帖子成功.' }
        format.json { render action: 'show', status: :created, location: @post }
      else
        format.html { render action: 'new' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    if !current_user.admin?&&current_user.id!=@post.user_id
      redirect_to @post, notice: "您无权编辑该帖"
      return
    end
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: '编辑帖子成功.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    if !current_user.admin?&&current_user.id!=@post.user_id
      redirect_to @post, notice: "您无权删除该帖"
      return
    end
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:user_id, :title, :text)
    end
end
