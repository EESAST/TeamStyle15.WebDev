class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :hashed_password
      t.string :salt
      t.string :true_name
      t.integer :student_number
      t.integer :team_id
      t.string :portait_path
      t.string :type

      t.timestamps
    end
  end
end
