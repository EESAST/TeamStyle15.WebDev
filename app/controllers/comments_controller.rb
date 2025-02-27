﻿class CommentsController < ApplicationController
  skip_before_filter :admin_authorize, only: [:new, :create, :update, :destroy, :edit]

  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.paginate(page: params[:page], :per_page => 15, :order => 'updated_at DESC' )
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)
    @comment.user_id=current_user.id
    
    respond_to do |format|
      if @comment.save
        if current_user.id!=Post.find(@comment.post_id).user_id
          @message=Message.new
          @message.user_id=Post.find(@comment.post_id).user_id
          @message.messagetype=1
          @message.content=@comment.id
          @message.read=false
          @message.save
        end

        format.html { redirect_to :back, notice: '评论成功' }
        format.json { render action: 'show', status: :created, location: @comment }
      else
        format.html { render action: 'new' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to post_path(@comment.post_id), notice: '修改评论成功' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @messages=Message.find(:all,:conditions=>{:messagetype=>1,:content=>@comment.id})
    @messages.each do |message|
      message.destroy
    end
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: '删除评论成功' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:user_id, :text, :post_id)
    end
end
