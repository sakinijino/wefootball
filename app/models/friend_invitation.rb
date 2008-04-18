class FriendInvitation < ActiveRecord::Base
  include ModelHelper
  
  belongs_to :applier, :class_name=>"User", :foreign_key=>"applier_id"
  belongs_to :host, :class_name=>"User", :foreign_key=>"host_id"

  validates_length_of :message, :maximum =>150, :allow_nil=>true, :message => "消息最长可以填150个字"
  
  attr_protected :applier_id, :host_id
  
  def before_validation
    attribute_slice(:message, 150)
  end
  
  def before_create
    self.apply_date = Date.today
  end
end
