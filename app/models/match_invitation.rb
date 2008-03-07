class MatchInvitation < ActiveRecord::Base
  
  MAX_DESCRIPTION_LENGTH = 3
  MAX_TEAM_MESSAGE_LENGTH = 300
  
  belongs_to :host_team, :class_name=>"Team", :foreign_key=>"host_team_id"
  belongs_to :guest_team, :class_name=>"Team", :foreign_key=>"guest_team_id"  
  
  MATCH_TYPES = [1,2]
  MATCH_SIZES = (5..11).to_a
  WIN_RULES = [1,2,3]
  
  attr_accessible :new_start_time, :new_location, :new_match_type, :new_size
  attr_accessible :new_has_judge, :new_has_card, :new_has_offside, :new_win_rule
  attr_accessible :new_description, :new_half_match_length, :new_rest_length
  
  validates_inclusion_of :new_match_type, :in => MATCH_TYPES
  validates_inclusion_of :new_size, :in => MATCH_SIZES
  validates_inclusion_of :new_win_rule, :in => WIN_RULES

  validates_length_of :new_description, :maximum =>MAX_DESCRIPTION_LENGTH
  validates_length_of :host_team_message, :maximum =>MAX_TEAM_MESSAGE_LENGTH
  validates_length_of :guest_team_message, :maximum =>MAX_TEAM_MESSAGE_LENGTH  

  def before_validation
    if self.host_team_message.nil?
      self.host_team_message = ""
    end
    if self.guest_team_message.nil?
      self.guest_team_message = ""      
    end
    if self.new_description.nil?
      self.new_description = ""      
    end 
    if self.new_description.chars.length > MAX_DESCRIPTION_LENGTH      
      self.new_description = (self.new_description.chars[0...MAX_DESCRIPTION_LENGTH]).to_s
    end
    if self.host_team_message.chars.length > MAX_TEAM_MESSAGE_LENGTH      
      self.host_team_message = (self.host_team_message.chars[0...MAX_TEAM_MESSAGE_LENGTH]).to_s
    end
    if self.guest_team_message.chars.length > MAX_TEAM_MESSAGE_LENGTH      
      self.guest_team_message = (self.guest_team_message.chars[0...MAX_TEAM_MESSAGE_LENGTH]).to_s
    end     
  end  

  def save_last_info!
    self.attributes.each do |a|
      if a[0][0..3] == "new_"
        self[a[0][4..-1].to_sym] = a[1]
      end
    end
  end
  
  def has_been_modified?(params)
    match_inv = MatchInvitation.new(params)
    self.attributes.each do |a|
      if a[0][0..3] == "new_"
        if a[1] != match_inv[a[0].to_sym]
          return true
        end
      end
    end
    return false
  end  
end
