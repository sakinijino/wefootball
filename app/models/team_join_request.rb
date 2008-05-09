class TeamJoinRequest < ActiveRecord::Base
  include ModelHelper
  
  belongs_to :user
  belongs_to :team
  
  attr_protected :user_id, :team_id  
  
  validates_length_of  :message, :maximum => 150, :allow_nil=>true, :message => "消息最长可以填150个字"

  def before_validation
    attribute_slice(:message, 150)
  end
  
  def before_create
    self.apply_date = Date.today
    User.update_all('team_join_invitations_count=team_join_invitations_count+1', ['id = ?', self.user_id]) if self.is_invitation
    Team.update_all('team_join_requests_count=team_join_requests_count+1', ['id = ?', self.team_id]) if !self.is_invitation
  end
  
  def before_destroy
    User.update_all('team_join_invitations_count=team_join_invitations_count-1', ['id = ?', self.user_id]) if self.is_invitation
    Team.update_all('team_join_requests_count=team_join_requests_count-1', ['id = ?', self.team_id]) if !self.is_invitation
  end
  
  def can_destroy_by?(user)
    return (self.user == user) || (user.is_team_admin_of?(self.team))
  end
  
  def can_accept_by?(user)
    return (self.is_invitation && user==self.user) || 
      (!self.is_invitation && user.is_team_admin_of?(self.team))
  end
end
