require 'open-uri'
class User < ActiveRecord::Base
  belongs_to :team
  has_many :posts, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :messages, :dependent => :destroy
  
  include Gravtastic
  gravtastic  :secure => false,
              :filetype => :png,
              :size => 512

  validates :name, :presence => {:presence => true, :message => "用户名不能为空"}, :uniqueness => {:uniqueness => true, :message => "该用户名已经被注册"}, :length=>{:maximum=>20,:message=>"用户名不能超过20个字符"}
  validates :password, :confirmation => true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create, message: "电子邮件地址无效" }, :presence => {:presence => true, :message => "邮箱不能为空"}, :uniqueness => {:uniqueness => true, :message => "该邮箱已经被注册"}
  validates :true_name, :presence => {:presence => true, :message => "姓名不能为空"}
  validates :student_number, :presence => {:presence => true, :message => "学号不能为空"}, :uniqueness => {:uniqueness => true, :message => "该学号已经被注册"} , :numericality => {:message => "学号输入错误", :only_integer => true, :less_than_or_equal_to => 2013999999, :greater_than => 2000000000}

  attr_accessor :password_confirmation
  attr_reader :password
  attr_accessor :portrait

  validate :password_must_be_present

  def User.authenticate(name, password)
    if user=find_by_email(name.downcase)||user=find_by_name(name)
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
    student_number==2012000000
    #一定要在公开运行之前注册admin这个用户名，或者使用命令行直接操作数据库，否则无法使用管理员账户！
  end 

  def upload(params)
    if uploaded_io=params[:user][:portrait]
      portrait_path="/uploads/portraits/#{Time.now.to_i.to_s}_#{params[:user][:name]}_#{uploaded_io.original_filename}"
      File.open("#{Rails.root}/public/#{portrait_path}", 'wb') do |file|  
        file.write(uploaded_io.read)
        file.close()
      end
      return portrait_path
    else
      return nil
    end
  end
  def fetch(user)
    portrait_path="/uploads/portraits/#{Time.now.to_i.to_s}_#{user.name}_gravatar_#{user.gravatar_url.split("/")[-1].split("?")[0]}"
    File.open("#{Rails.root}/public/#{portrait_path}", "wb") do |saved_file|
      open(user.gravatar_url, 'rb') do |read_file|
        saved_file.write(read_file.read)
      end
    end
    portrait_path
  end

  private

  def password_must_be_present
    errors.add(:password, "请输入密码") unless hashed_password.present?
  end

  def generate_salt
    self.salt = self.object_id.to_s + rand.to_s
  end
 
end
