class AddTestBattleToUser < ActiveRecord::Migration
  def change
    add_column :users, :test1, :integer
    add_column :users, :test2, :integer
    add_column :users, :test3, :integer
    add_column :users, :test4, :integer
    add_column :users, :test5, :integer
    add_column :users, :test6, :integer
    add_column :users, :test7, :integer
    add_column :users, :test8, :integer
    add_column :users, :test9, :integer
    add_column :users, :test0, :integer
  end
end
