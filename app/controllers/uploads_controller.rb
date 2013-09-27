class UploadsController < ApplicationController
  skip_before_filter :admin_authorize, only: [:create,:edit, :update, :destroy]
  before_action :set_upload, only: [:show, :edit, :update, :destroy]

  # GET /uploads
  # GET /uploads.json
  def index
    @uploads = Upload.all
  end

  # GET /uploads/1
  # GET /uploads/1.json
  def show
  end

  # GET /uploads/new
  def new
    @upload = Upload.new
  end

  # GET /uploads/1/edit
  def edit
  end

  # POST /uploads
  # POST /uploads.json
  def create
    @upload = Upload.new(upload_params)
    if (Team.find(@upload.team_id).captain_id!=current_user.id)
      redirect_to :back, :notice=>"您没有权限上传AI"
      return
    end

    if uploaded_path=@upload.upload(params)
      @upload.path=uploaded_path.to_s
    else
      redirect_to :back, :notice=>"上传失败"
      return
    end

    respond_to do |format|
      if @upload.save
        format.html { redirect_to team_path(current_user.team_id), notice: '上传成功' }
        format.json { render action: 'show', status: :created, location: @upload }
      else
        format.html { render action: 'new' }
        format.json { render json: @upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /uploads/1
  # PATCH/PUT /uploads/1.json
  def update
    if uploaded_path=@upload.upload(params)
      File.delete("#{Rails.root}/public/#{@upload.path}") if File.exist?("#{Rails.root}/public/#{@upload.path}")
      @upload.path=uploaded_path.to_s
    else
      redirect_to :back, :notice=>"上传失败"
      return
    end

    respond_to do |format|
      if @upload.update(upload_params)
        format.html { redirect_to @upload, notice: 'Upload was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /uploads/1
  # DELETE /uploads/1.json
  def destroy
    File.delete("#{Rails.root}/public/#{@upload.path}") if File.exist?("#{Rails.root}/public/#{@upload.path}")
    @upload.destroy
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_upload
      @upload = Upload.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def upload_params
      params.require(:upload).permit(:uploaded_file,:team_id,:user_id)
    end
end
