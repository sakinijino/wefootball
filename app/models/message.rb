class Message < ActiveRecord::Base
  belongs_to :sender, :class_name=>"User", :foreign_key=>"sender_id"
  belongs_to :receiver, :class_name=>"User", :foreign_key=>"receiver_id"
  
  validates_presence_of     :content, :subject
  validates_length_of       :content, :maximum =>2000
  validates_length_of       :subject, :maximum =>200
end
