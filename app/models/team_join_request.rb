class TeamJoinRequest < ActiveRecord::Base
  belongs_to :user
  belongs_to :team
  
  attr_protected :user_id, :team_id  
  
  validates_length_of  :message, :maximum => 500

  def before_validation
    self.message = self.message.slice(0, 500) if self.message.jlength > 500
  end
  
  def before_create
    self.apply_date = Date.today
  end
  
  def can_destroy_by?(user)
    return (self.user == user) || (user.is_team_admin_of?(self.team))
  end
  
  def can_accept_by?(user)
    return (self.is_invitation && user==self.user) || 
      (!self.is_invitation && user.is_team_admin_of?(self.team))
  end
end
