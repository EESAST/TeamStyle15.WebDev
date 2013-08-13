class Team < ActiveRecord::Base
  has_many :users,dependent: :nullify
  
  validates :name, :presence => {:presence => true, :message => "不能为空"}, :uniqueness => {:uniqueness => true, :message => "已经被占用"}
  validates :captain_id, :presence => {:presence => true, :message => "不能为空"}
end
