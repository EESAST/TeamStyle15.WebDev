class AddClassNumberToUsers < ActiveRecord::Migration
  def change
    add_column :users, :class_number, :string
  end
end
