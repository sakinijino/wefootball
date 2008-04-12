class Match < ActiveRecord::Base
  include ModelHelper
  
  MAX_DESCRIPTION_LENGTH = 3000 
  
  TIME_LENGTH_TO_CLOSE_MATCH = 7
  
  SITUATIONS = (1..8).to_a  
  
  attr_accessible
  
  has_many :posts, :dependent => :nullify, :order => "updated_at desc" do
    def team(team_id, options={})
      find :all, {:conditions => ['team_id = ?', team_id]}.merge(options)
    end
    def team_public(team_id, options={})
      find :all, {:conditions => ['team_id = ? and is_private = ?', team_id, false]}.merge(options)
    end
  end
  
  has_many :match_joins,
            :dependent => :destroy  do
    def host_team
      find :all, :conditions => ['team_id = ?', @owner.host_team_id]
    end
    def guest_team
      find :all, :conditions => ['team_id = ?', @owner.guest_team_id]
    end
  end
  
  validates_presence_of     :start_time, :location, :size
  validates_length_of       :description, :maximum =>MAX_DESCRIPTION_LENGTH, :allow_nil => true
  validates_inclusion_of   :situation_by_host, :situation_by_guest, :in => SITUATIONS, :allow_nil=>true  
  validates_numericality_of :host_team_goal_by_host, :guest_team_goal_by_host, :allow_nil=>true   
  validates_numericality_of :host_team_goal_by_guest, :guest_team_goal_by_guest, :allow_nil=>true 
  
  belongs_to :host_team, :class_name=>"Team", :foreign_key=>"host_team_id"
  belongs_to :guest_team, :class_name=>"Team", :foreign_key=>"guest_team_id"
  
  def before_save
    self.half_match_length = 0 if self.half_match_length.nil?
    self.rest_length = 0 if self.rest_length.nil?    
    self.end_time = self.start_time.since(60 * self.full_match_length)
  end
  
  def full_match_length
    2*self.half_match_length + self.rest_length
  end
  
  def before_validation
    attribute_slice(:description, MAX_DESCRIPTION_LENGTH)
    if self.size.nil?
      self.size = 11
    end   
  end

  def self.calculate_situation(host_team_goal,guest_team_goal)
    if(host_team_goal.nil? || guest_team_goal.nil?)
      return 1
    elsif(!host_team_goal.nil? && !guest_team_goal.nil?)
      return calculate_situation_from_goal(host_team_goal,guest_team_goal)
    end
  end  
  
  def self.create_by_invitation(invitation)
    match = Match.new
    match.start_time = invitation.new_start_time
    match.location = invitation.new_location
    match.match_type = invitation.new_match_type
    match.size = invitation.new_size
    match.has_judge = invitation.new_has_judge
    match.has_card = invitation.new_has_card
    match.has_offside = invitation.new_has_offside
    match.win_rule = invitation.new_win_rule
    match.description = invitation.new_description
    match.half_match_length = invitation.new_half_match_length
    match.rest_length = invitation.new_rest_length
    match.host_team_id = invitation.host_team_id
    match.guest_team_id = invitation.guest_team_id
    match.save!
    match
  end

  def is_before_match?
    return Time.now < self.start_time
  end
  
  def is_after_match_and_before_match_close?
    return ((Time.now > self.end_time) && (TIME_LENGTH_TO_CLOSE_MATCH.days.ago < self.end_time))
  end
  
  def is_before_match_close?
    return TIME_LENGTH_TO_CLOSE_MATCH.days.ago < self.end_time   
  end
  
  def has_team_member?(user, team_id)
    return false if !belongs_to?(team_id)
    user_id = case user
    when User
      user.id
    else
      user
    end
    MatchJoin.find :first, :conditions => ['user_id = ? and team_id = ? and match_id = ?', user_id, team_id, self.id]
  end
  
  def has_joined_team_member?(user, team_id)
    return false if !belongs_to?(team_id)
    tj = has_team_member?(user, team_id)
    tj!=nil && tj.status == MatchJoin::JOIN
  end
  
  def can_be_joined_by?(user, team)
    team_id = case team
    when Team
      team.id
    else
      team
    end
    belongs_to?(team_id) && is_before_match? && user.is_team_member_of?(team_id) && !has_joined_team_member?(user, team_id)
  end
  
  def can_be_quited_by?(user, team)
    team_id = case team
    when Team
      team.id
    else
      team
    end
    belongs_to?(team_id) && is_before_match? && has_team_member?(user, team_id)
  end
  
  def can_be_edited_result_by?(user, team)
    is_after_match_and_before_match_close? && self.can_be_edited_by?(user, team)
  end
  
  def can_be_edited_formation_by?(user, team)
    is_before_match_close? && self.can_be_edited_by?(user, team)
  end
  
  def can_be_destroyed_by?(user)
    is_before_match? && self.is_team_admin_of?(user)
  end  

  protected  
  def can_be_edited_by?(user, team)
    self.belongs_to?(team) && user.is_team_admin_of?(team)
  end
  
  def belongs_to?(team)
    team_id = case team
    when Team
      team.id
    else
      team
    end
    self.host_team_id == team_id || self.guest_team_id == team_id
  end
  
  def is_team_admin_of?(user)
    user.is_team_admin_of?(self.host_team_id)|| user.is_team_admin_of?(self.guest_team_id)
  end
  
  def self.calculate_situation_from_goal(host_team_goal, guest_team_goal)
    distinct_goals = (host_team_goal.to_i - guest_team_goal.to_i)
    if distinct_goals > 4
      return 2
    elsif distinct_goals > 2
      return 3
    elsif distinct_goals > 0
      return 4
    elsif distinct_goals == 0
      return 5
    elsif distinct_goals > -3
      return 6
    elsif distinct_goals > -5
      return 7
    else return 8
    end
  end
end
