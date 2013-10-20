class DevelopController < ApplicationController
  skip_before_filter :admin_authorize
  before_filter :authenticate

  def index
    @develop = ReleaseFile.paginate(page: params[:page]).order(:created_at)
  end

  def upload
    @release_file=ReleaseFile.new
    if uploaded_path=@release_file.upload(params)
      File.delete("#{Rails.root}/public/downloads/#{@release_file.path}") if File.exist?("#{Rails.root}/public/downloads/#{@release_file.path}") && @release_file.path
      @release_file.path=uploaded_path
      @release_file.name=(file_array=@release_file.path.split('.'))[0..(file_array.length>1 ? -2 : -1)].join('.')
      extra_notice=''
      if @old_file=ReleaseFile.find_by_path(@release_file.path)
        @release_file=@old_file
        extra_notice=" 注意 原文件"+@release_file.path+"已经被覆盖"
      end
      @release_file.release=true
      if @release_file.save!
        redirect_to :back, :notice=>"上传成功"+extra_notice
        return
      end
      redirect_to :back, :notice=>"保存失败"
      return
    else
      redirect_to :back, :notice=>"上传失败"
      return
    end
  end

  def release
    @file=ReleaseFile.find_by_id(params[:release_file_id])
    if nil==@file
      redirect_to :back, :notice=>"请求无效"
      return
    end
    @file.release=true
    if @file.save!
      redirect_to :back, :notice=>"保存成功"
      return
    else
      redirect_to :back, :notice=>"保存失败"
    end
  end

  def unrelease
    @file=ReleaseFile.find_by_id(params[:release_file_id])
    if nil==@file
      redirect_to :back, :notice=>"请求无效"
      return
    end
    @file.release=false
    if @file.save!
      redirect_to :back, :notice=>"保存成功"
      return
    else
      redirect_to :back, :notice=>"保存失败"
    end
  end

  def delete
    @file=ReleaseFile.find_by_id(params[:release_file_id])
    if ReleaseFile.destroy(params[:release_file_id]) && File.delete("#{Rails.root}/public/downloads/#{@file.path}")
      redirect_to :back, :notice=>"删除成功"
      return
    else
      redirect_to :back, :notice=>"删除失败"
    end
  end
  
  def rename
    @file=ReleaseFile.find_by_id(params[:release_file_id])
    if nil==@file
      redirect_to :back, :notice=>"请求无效"
      return
    end
    if params[:file_name].empty?
      redirect_to :back, :notice=>"文件名不能为空"
      return
    end
    @file.name=params[:file_name]
    if @file.save!
      redirect_to :back, :notice=>"保存成功"
      return
    else
      redirect_to :back, :notice=>"保存失败"
    end
  end

private 
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "foo" && password == "bar"
    end
  end
end
