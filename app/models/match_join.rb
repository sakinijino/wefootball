class MatchJoin < ActiveRecord::Base

  UNDETERMINED = 0
  JOIN = 1
  
  CARDS = [0,1,2,3]
  
  belongs_to :team
  belongs_to :match
  belongs_to :user
  
  validates_inclusion_of   :position, :in => Team::FORMATION_POSITIONS, :allow_nil => true, :message => "不要自己构造表单提交..."
  validates_numericality_of :goal, :message => "进球数需要填写整数", :only_integer => true
  validates_inclusion_of    :goal, :allow_nil=>true, :in => 0..99, :message => "真的进了这么多球吗？"
  validates_inclusion_of   :cards, :in => CARDS, :allow_nil => true, :message => "不要自己构造表单提交..."
  attr_accessible :goal, :cards
  
  def before_validation
    self.position = nil if self.position==""
    if self.position!=nil && 
       (self.goal.nil? || self.goal.zero?) && 
       (self.yellow_card.nil? || self.yellow_card.zero?) && 
       (self.red_card.nil? || self.red_card.zero?)
      ut = UserTeam.find_by_user_id_and_team_id(self.user_id, self.team_id)
      self.position = nil if ut.nil? || !ut.is_player
    end
    self.goal=0 if self.goal.blank?
  end
  
  def self.create_joins(match)
    host_team = match.host_team
    for user in host_team.users
      mj = MatchJoin.new
      mj.match_id = match.id
      mj.team_id = host_team.id
      mj.user_id = user.id
      mj.status = UNDETERMINED
      mj.save!
    end
    guest_team = match.guest_team
    for user in guest_team.users
      mj = MatchJoin.new
      mj.match_id = match.id
      mj.team_id = guest_team.id
      mj.user_id = user.id
      mj.status = UNDETERMINED    
      mj.save!
    end
  end
  
  def self.players(match_id,team_id)
    MatchJoin.find(:all,
                   :select => 'mj.*',
                   :conditions => ["mj.match_id=? and mj.team_id=? and (mj.position is not null or mj.goal>0 or mj.yellow_card>0 or mj.red_card>0 or ut.is_player=true)",match_id,team_id],
                   :joins => 'as mj inner join user_teams as ut on mj.team_id=ut.team_id and mj.user_id=ut.user_id'
                   )
  end
  
  def cards
    if !self.yellow_card.nil? && !self.red_card.nil?
      return self.yellow_card + self.red_card
    end
  end
  
  def cards=(type_num)
    result = MatchJoin.split_cards(type_num)
    self.yellow_card = result[0]
    self.red_card = result[1]
  end  
  
  def self.split_cards(type_num)
    case type_num.to_i
    when 0
      return [0,0]
    when 1
      return [1,0]
    when 2
      return [1,1]
    when 3
      return [2,1]
    else #非法情况
      return [0,0]
    end
  end
end
