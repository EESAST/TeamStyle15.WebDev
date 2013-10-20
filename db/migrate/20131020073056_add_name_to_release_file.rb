class AddNameToReleaseFile < ActiveRecord::Migration
  def change
    add_column :release_files, :name, :string
  end
end
