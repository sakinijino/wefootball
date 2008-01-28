class PreFriendRelation < ActiveRecord::Base
  belongs_to :applier, :class_name=>"User", :foreign_key=>"applier_id"
  belongs_to :host, :class_name=>"User", :foreign_key=>"host_id"

  validates_length_of :message, :maximum =>500  
  
  def before_create
    self.apply_date = Date.today
  end  
end
