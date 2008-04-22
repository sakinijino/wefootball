class Message < ActiveRecord::Base
  belongs_to :sender, :class_name=>"User", :foreign_key=>"sender_id"
  belongs_to :receiver, :class_name=>"User", :foreign_key=>"receiver_id"
  
  validates_presence_of     :subject, :message => "请填写标题"
  validates_length_of     :content, :minimum =>2, :message => "别吝惜笔墨, 最少也写2个字吧"
  validates_length_of       :content, :maximum =>3000, :message => "内容最长可以填3000个字"
  validates_length_of       :subject, :maximum =>50, :message => "标题最长可以填50个字"
  
  attr_accessible :subject, :content
  
  def can_read_by?(user)
    user_id = case user
    when User
      user.id
    else
      user
    end
    (self.sender_id == user_id && !self.is_delete_by_sender) || 
      (self.receiver_id == user_id && !self.is_delete_by_receiver)
  end
  
  def destroy_by!(user)
    if(self.sender_id == user.id )
      self.is_delete_by_sender = true
    elsif (self.receiver_id == user.id)
      self.is_delete_by_receiver = true
    end
    (self.is_delete_by_sender && self.is_delete_by_receiver) ? self.destroy : self.save!
  end
end
