class Team < ActiveRecord::Base
  has_many :users,dependent: :nullify
  
  validates :name, :presence => {:presence => true, :message => "队伍名不能为空"}, :uniqueness => {:uniqueness => true, :message => "该队伍名已经被占用"}
end
