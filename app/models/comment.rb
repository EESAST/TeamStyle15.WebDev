﻿class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  
  validates :text, :presence=>{:presence=>true,:message=>'评论内容不能为空'}

end
