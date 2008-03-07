class Match < ActiveRecord::Base

  MAX_DESCRIPTION_LENGTH = 3000
  
  SITUATIONS = (1..8).to_a  
  
  validates_presence_of     :start_time, :location
  validates_length_of       :description, :maximum =>MAX_DESCRIPTION_LENGTH
  validates_inclusion_of   :situation_by_host, :situation_by_guest, :in => Position::POSITIONS, :allow_nil=>true  
  validates_numericality_of :host_team_goal_by_host, :guest_team_goal_by_host, :allow_nil=>true   
  validates_numericality_of :host_team_goal_by_guest, :guest_team_goal_by_guest, :allow_nil=>true 

  attr_accessible :host_team_goal, :guest_team_goal, :situation
  
  belongs_to :host_team, :class_name=>"Team", :foreign_key=>"host_team_id"
  belongs_to :guest_team, :class_name=>"Team", :foreign_key=>"guest_team_id"
  
  def before_validation
    if !self.description.nil? && self.description.chars.length > MAX_DESCRIPTION_LENGTH      
      self.description = (self.description.chars[0...MAX_DESCRIPTION_LENGTH]).to_s
    end
  end

  def calculate_situation(host_team_goal,guest_team_goal)
    if(host_team_goal.nil? || guest_team_goal.nil?)
      return 1
    elsif(!guest_team_goal.nil? && !guest_team_goal.nil?)
      return calculate_situation_from_goal(host_team_goal,guest_team_goal)
    end
  end  
  
  def self.new_by_invitation(invitation)
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
    return match
  end

  protected
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
    
    def calculate_situation_from_goal(host_team_goal, guest_team_goal)
      distinct_goals = (host_team_goal.to_i - guest_team_goal.to_i)
      p "distinct_goals:"+distinct_goals.to_s
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
