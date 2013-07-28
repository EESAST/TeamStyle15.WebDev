class User < ActiveRecord::Base
  include Gravtastic
  gravtastic :size => 512

  validates :name, :presence => {:presence => true, :message => "不能为空"}, :uniqueness => true
  validates :password, :confirmation => true
  validates :email, :presence => true, :uniqueness => true
  validates :true_name, :presence => true
  validates :student_number, :presence => true, :numericality => {:message => "学号输入错误", :only_integer => true, :less_than_or_equal_to => 2013999999, :greater_than => 2000000000}

  attr_accessor :password_confirmation
  attr_reader :password

  validate :password_must_be_present

  def User.authenticate(name, password)
    if user = find_by_name(name)
      if user.hashed_password == encrypt_password(password, user.salt)
        use
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

  private

  def password_must_be_present
    errors.add(:password, "请输入密码") unless hashed_password.present?
  end

  def generate_salt
    self.salt = self.object_id.to_s + rand.to_s
  end
  
end
