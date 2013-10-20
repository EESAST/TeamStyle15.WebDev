class CreateReleaseFiles < ActiveRecord::Migration
  def change
    create_table :release_files do |t|
      t.string :path
      t.boolean :release

      t.timestamps
    end
  end
end
