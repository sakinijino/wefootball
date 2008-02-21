class UserTeam < ActiveRecord::Base
  belongs_to :user
  belongs_to :team
  
  attr_protected :user_id, :team_id
  
  def can_destroy_by?(user)
    return false if (self.team.users.admin.length==1 && self.user.is_team_admin_of?(self.team))
    user.is_team_admin_of?(self.team) || self.user==user
  end
end
