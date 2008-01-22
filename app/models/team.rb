class Team < ActiveRecord::Base
  has_many :user_teams
  has_many :users, :through=>:user_teams do
    def admin
      find :all, :conditions => ['is_admin = ?', true]
    end
  end
  
  has_many :team_join_requests,
            :dependent => :destroy
  
  validates_presence_of     :name, :shortname
  validates_length_of        :name,    :maximum => 200
  validates_length_of        :shortname,    :maximum => 20
  validates_length_of        :summary,    :maximum => 700
  validates_length_of        :style,    :maximum => 20
  
  def request_join_users
    User.find(:all,
      :select => "tjr.id as r_id, tjr.message, tjr.apply_date, u.*",
      :joins => " as u inner join team_join_requests as tjr on u.id = tjr.user_id and tjr.is_invitation = false",
      :conditions => ["tjr.team_id = :tid", {:tid=>self.id}]
    )
  end
  
  def invited_join_users
    User.find(:all,
      :select => "tjr.id as r_id, tjr.message, tjr.apply_date, u.*",
      :joins => " as u inner join team_join_requests as tjr on u.id = tjr.user_id and tjr.is_invitation = true",
      :conditions => ["tjr.team_id = :tid", {:tid=>self.id}]
    )
  end
end
