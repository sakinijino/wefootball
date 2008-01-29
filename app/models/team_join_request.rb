class TeamJoinRequest < ActiveRecord::Base
  belongs_to :user
  belongs_to :team
  
  validates_length_of       :message, :maximum => 500
  
  def before_create
    self.apply_date = Date.today
  end
  
  def can_destroy_by?(user)
    return (self.user == user) || (self.team.users.admin.include?(user))
  end
  
  def can_accept_by?(user)
    return (self.is_invitation && user==self.user) || 
      (!self.is_invitation && self.team.users.admin.include?(user))
  end
end
