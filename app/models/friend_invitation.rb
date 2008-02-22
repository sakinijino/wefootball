class FriendInvitation < ActiveRecord::Base
  belongs_to :applier, :class_name=>"User", :foreign_key=>"applier_id"
  belongs_to :host, :class_name=>"User", :foreign_key=>"host_id"

  validates_length_of :message, :maximum =>500  
  
  attr_protected :applier_id, :host_id
  
  def before_validation
    self.message = self.message.slice(0, 500)
  end
  
  def before_create
    self.apply_date = Date.today
  end
  
end
