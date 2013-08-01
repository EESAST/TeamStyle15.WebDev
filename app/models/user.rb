class User < ActiveRecord::Base
  belongs_to :team
  has_many :posts, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  
  include Gravtastic
  gravtastic :size => 512

  validates :name, :presence => {:presence => true, :message => "不能为空"}, :uniqueness => {:uniqueness => true, :message => "已经被注册"}
  validates :password, :confirmation => true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create, message: "无效" }, :presence => {:presence => true, :message => "不能为空"}, :uniqueness => {:uniqueness => true, :message => "已经被注册"}
  validates :true_name, :presence => {:presence => true, :message => "不能为空"}
  validates :student_number, :presence => {:presence => true, :message => "不能为空"}, :uniqueness => {:uniqueness => true, :message => "已经被注册"} , :numericality => {:message => "学号输入错误", :only_integer => true, :less_than_or_equal_to => 2013999999, :greater_than => 2000000000}

  attr_accessor :password_confirmation
  attr_reader :password

  validate :password_must_be_present

  def User.authenticate(name, password)
    if user = find_by_name(name)
      if user.hashed_password == encrypt_password(password, user.salt)
        user
      end
    end
  end

  def User.encrypt_password(password, salt)
    Digest::SHA2.hexdigest(password + "TeamStyle15" + salt)
  end

  def password=(password)
    @password = password

    if password.present?
      generate_salt
      self.hashed_password = self.class.encrypt_password(password, salt)
    end
  end
  
  def admin?
    name == 'admin'
    #一定要在公开运行之前注册admin这个用户名，或者使用命令行直接操作数据库，否则无法使用管理员账户！
  end
  
  private

  def password_must_be_present
    errors.add(:password, "请输入密码") unless hashed_password.present?
  end

  def generate_salt
    self.salt = self.object_id.to_s + rand.to_s
  end
  
end
