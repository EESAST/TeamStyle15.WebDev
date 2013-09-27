class AddPostTypeToPost < ActiveRecord::Migration
  def change
    add_column :posts, :post_type, :integer
  end
end
