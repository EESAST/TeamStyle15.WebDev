class Team < ActiveRecord::Base
  has_many :users,dependent: :nullify
  has_many :uploads,dependent: :destroy

  
  validates :name, :presence => {:presence => true, :message => "队伍名不能为空"}, :uniqueness => {:uniqueness => true, :message => "该队伍名已经被占用"}
  def full?
    return (self.users.count>=4)?true:false
  end
end
