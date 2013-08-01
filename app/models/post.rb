class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments, :dependent => :destroy
  
  validates :title, :presence => {:presence => true, :message => "不能为空"}
  validates :text, :presence => {:presence => true, :message => "不能为空"}
  
end
