class ReleaseFile < ActiveRecord::Base
  def upload(params)
    if uploaded_io=params[:release_file]
      filename=uploaded_io.original_filename
      File.open("#{Rails.root}/public/downloads/#{filename}", 'wb') do |file|  
        file.write(uploaded_io.read)
        file.close()
      end
      return filename
    else
      return nil
    end
  end
end
