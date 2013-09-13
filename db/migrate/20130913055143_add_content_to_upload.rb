class AddContentToUpload < ActiveRecord::Migration
  def change
    add_column :uploads, :path, :string
    add_column :uploads, :user_id, :integer
  end
end
