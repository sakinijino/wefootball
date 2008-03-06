class UserTeam < ActiveRecord::Base
  FORMATION_MAX_LENGTH = 11
  
  belongs_to :user
  belongs_to :team
  
  attr_protected :user_id, :team_id
  
  validates_inclusion_of   :position, :in => Team::FORMATION_POSITIONS, :allow_nil => true
  
  def before_validation
    self.position=nil if !self.is_player
    self.position = nil if self.position==""
  end
  
  def before_save
    if self.position != nil
      uts = UserTeam.team_formation(self.team_id)
      if (uts.size >= FORMATION_MAX_LENGTH)
        self.position = nil
      else
        uts.each do |ut| 
          ut.update_attributes!(:position => nil) if ut.position == self.position
        end
      end
    end
  end
  
  def self.team_formation(team)
    team_id = case team
    when Team
      team.id
    else
      team
    end
    UserTeam.find :all, :conditions => ['team_id = ? and position is not null', team_id]
  end
  
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
