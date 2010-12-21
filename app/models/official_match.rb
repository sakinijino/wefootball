class OfficialMatch < ActiveRecord::Base
  include ModelHelper
  
  MAX_DESCRIPTION_LENGTH = 3000
  MAX_LOCATION_LENGTH = 100
  
  belongs_to :user
  
  belongs_to :host_team, :class_name=>"OfficialTeam", :foreign_key=>"host_official_team_id"
  belongs_to :guest_team, :class_name=>"OfficialTeam", :foreign_key=>"guest_official_team_id"
  
  has_many :match_reviews, :foreign_key=>"match_id", :class_name=>"OfficialMatchReview", :dependent => :destroy
  has_many :watches, :dependent => :destroy
  
  validates_length_of :location, :maximum => MAX_LOCATION_LENGTH, :message=>"场地名称最长可以填#{MAX_LOCATION_LENGTH}个字"
  
  validates_length_of       :description, :maximum =>MAX_DESCRIPTION_LENGTH, :allow_nil => true
  validates_numericality_of :host_team_goal, :guest_team_goal, :host_team_pk_goal, :guest_team_pk_goal,
    :only_integer => true, :allow_nil=>true, :message => "进球数需要填写整数"
  validates_inclusion_of    :host_team_goal, :guest_team_goal, :host_team_pk_goal, :guest_team_pk_goal, 
    :allow_nil=>true, :in => 0..99, :message => "真的进了这么多球吗？"
  
  attr_protected :user_id
  
  def before_save       
    self.end_time = self.start_time.since(60 * 105)
  end
  
  def before_validation
    self.start_time = DateTime.now.tomorrow if self.start_time==nil
    attribute_slice(:description, MAX_DESCRIPTION_LENGTH)    
  end
  
  def pk?
    !host_team_pk_goal.nil? && !guest_team_pk_goal.nil? && 
      (!host_team_pk_goal.zero? || !guest_team_pk_goal.zero?)
  end
  
  def started?
    Time.now > self.start_time
  end
  
  def finished?
    Time.now > self.end_time
  end
  
  def host_team_name
    self.host_team.name
  end
  
  def guest_team_name
    self.guest_team.name
  end
  
  def result_text
    if finished? && !host_team_goal.nil? && !guest_team_goal.nil?
      if pk?
        "#{host_team_goal}<span class='pk_goal'>(#{host_team_pk_goal})</span> : #{guest_team_goal}<span class='pk_goal'>(#{guest_team_pk_goal})</span>"
      else
        "#{host_team_goal} : #{guest_team_goal}"
      end
    else
      "V.S."
    end
  end
  
  ICON = "match_icon.gif"
  IMG_TITLE = "比赛"
  def icon
    self.class::ICON
  end
  
  def img_title
    self.class::IMG_TITLE
  end

  def self.import_match(m)
    host_team = OfficialTeam.find_or_initialize_by_name m[:host_name]
    guest_team = OfficialTeam.find_or_initialize_by_name m[:guest_name]
    new_teams =[]
    if host_team.new_record?
      host_team.category = m[:host_team_type]
      host_team.save!
      new_teams << host_team
    elsif !m[:host_team_type].nil? && host_team.category != m[:host_team_type]
      host_team.category = m[:host_team_type]
      host_team.save!
    end

    if guest_team.new_record?
      guest_team.category = m[:guest_team_type]
      guest_team.save!
      new_teams << guest_team
    elsif !m[:guest_team_type].nil? && guest_team.category != m[:guest_team_type]
      guest_team.category = m[:guest_team_type]
      guest_team.save!
    end

    new_match = []
    update_match = []
    match = OfficialMatch.find(:first, :conditions => ["host_official_team_id = ? and guest_official_team_id = ? and (start_time > ? and start_time < ?)", host_team.id, guest_team.id, m[:start_time] - 36.hours, m[:start_time] + 36.hours])
    match = OfficialMatch.new({
      :host_official_team_id => host_team.id,
      :guest_official_team_id => guest_team.id,
      :start_time => m[:start_time],
    }) if match == nil
    if match.new_record?
      match.host_team_goal = m[:host_goal] if m[:host_goal] != nil
      match.guest_team_goal = m[:guest_goal] if m[:guest_goal] != nil
      match.save!
      new_match << match
    elsif match.host_team_goal!=m[:host_goal] || 
          match.guest_team_goal!=m[:guest_goal] || 
          match.start_time.strftime("%Y-%m-%d %H:%M") != m[:start_time].strftime("%Y-%m-%d %H:%M") # i hate time zone
      match.host_team_goal = m[:host_goal] if m[:host_goal] != nil
      match.guest_team_goal = m[:guest_goal] if m[:guest_goal] != nil
      match.start_time = m[:start_time];
      match.save!
      update_match << match
    end
    
    yield new_teams, new_match, update_match if block_given?

    match
  end

end
