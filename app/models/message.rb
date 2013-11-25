class Message < ActiveRecord::Base
  belongs_to :user
  #user_id：接收消息的用户的id
  #messagetype定义：
    #0：未定义
    #1：帖子新评论
    #2：评论回复
    #3：用户入队申请
    #4：加入队伍邀请
    #5：@
    #6：私信
  #content：根据消息类别不同的消息内容的id
    #1：评论id
    #3：申请入队用户id
    #4：发邀队伍id
    #5：被@的评论id
    #6：发信人id
  #read：是否已读
  #text：附加信息
    #6：信息内容

end
