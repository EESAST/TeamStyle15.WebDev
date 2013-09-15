class Message < ActiveRecord::Base
  belongs_to :user
  #user_id：接收消息的用户的id
  #messagetype定义：
    #0：未定义
    #1：帖子新评论
    #2：评论回复
    #3：入队申请
    #4：@
  #content：根据消息类别不同的消息内容的id
    #1：评论id
  #read：是否已读
  #text：附加信息

end
