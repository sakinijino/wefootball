class UserTeam < ActiveRecord::Base
  belongs_to :user
  belongs_to :team
  
  attr_protected :user_id, :team_id
  
  def can_destroy_by?(user)
    (user.is_team_admin_of?(self.team_id) || self.user==user) && !is_the_only_one_admin?
  end
  
  def can_promote_as_admin_by?(user)
    !self.is_admin && user.is_team_admin_of?(self.team_id)
  end
  
  def can_degree_as_common_user_by?(user) 
    (self.is_admin) && (user.is_team_admin_of?(self.team_id)) && !is_the_only_one_admin?
  end

private
  def is_the_only_one_admin?
    self.is_admin && (UserTeam.count(:conditions=>["team_id = :tid and is_admin = true",{:tid=>self.team_id}])==1)
  end
end
