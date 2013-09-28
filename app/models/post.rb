class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments, :dependent => :destroy
  
  validates :title, :presence => {:presence => true, :message => "不能为空"}, :length => { :maximum => 40,:message=>"不能多于40字"}
  validates :text, :presence => {:presence => true, :message => "不能为空"}
  
  #post_type定义
  #nil/0:灌水
  #1:问题反馈
  #2:战术讨论
  #3:战友招募
end


