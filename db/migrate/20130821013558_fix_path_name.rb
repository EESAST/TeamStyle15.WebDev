class FixPathName < ActiveRecord::Migration
  def change
    rename_column :users, :portait_path, :portrait_path
  end
end
