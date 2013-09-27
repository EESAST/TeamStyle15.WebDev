class AddTeamidToUpload < ActiveRecord::Migration
  def change
    add_column :uploads, :team_id, :integer
  end
end
