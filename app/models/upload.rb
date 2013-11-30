class Upload < ActiveRecord::Base
  belongs_to :team
  validate :time_validate

  def Upload.time_validate?
    Time.now>=upload_begin && Time.now<upload_end
  end


  def Upload.upload_begin
    Time.local(2013,9,13,14)
  end

  def Upload.upload_end
    Time.local(2014,1,1,0)
  end

  
  def upload(params)
    if uploaded_io=params[:upload][:upload_file]
      path="/uploads/ai/#{Team.find(params[:upload][:team_id]).name}_#{Time.now.to_i.to_s}_#{uploaded_io.original_filename}"
      File.open("#{Rails.root}/public/#{path}", 'wb') do |file|  
        file.write(uploaded_io.read)
        file.close()
      end
      return path
    else
      return nil
    end
  end

private
  def time_validate
    errors.add(:时间,"目前不是有效的上传时间") unless 
    (Time.now>=Upload.upload_begin && Time.now<Upload.upload_end)
  end
end
