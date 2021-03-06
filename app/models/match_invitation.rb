class MatchInvitation < ActiveRecord::Base
  include ModelHelper
  include AttributesTracking
  
  MAX_DESCRIPTION_LENGTH = 3000
  MAX_TEAM_MESSAGE_LENGTH = 300
  MAX_LOCATION_LENGTH = 100
  
  belongs_to :host_team, :class_name=>"Team", :foreign_key=>"host_team_id"
  belongs_to :guest_team, :class_name=>"Team", :foreign_key=>"guest_team_id"

  belongs_to :new_football_ground, :class_name=>"FootballGround", :foreign_key=>"new_football_ground_id"  
  
  MATCH_TYPES = [1,2]
  MATCH_SIZES = (5..11).to_a
  WIN_RULES = [1,2,3]
  
  attr_accessible :new_start_time, :new_location, :new_match_type, :new_size
  attr_accessible :new_has_judge, :new_has_card, :new_has_offside, :new_win_rule
  attr_accessible :new_description, :new_half_match_length, :new_rest_length
  attr_accessible :new_location, :new_football_ground_id
  
  validates_presence_of     :new_location, :message => "请填写或选择比赛场地"
  
  validates_presence_of     :new_start_time, :message => "请填写比赛开始时间"
  
  validates_length_of        :new_location, :maximum => MAX_LOCATION_LENGTH, :message => "场地名称最长可以填#{MAX_LOCATION_LENGTH}个字"
  
  validates_numericality_of :new_half_match_length, :message => "半场时间需要填写整数", :only_integer => true
  validates_numericality_of :new_rest_length, :message => "中场休息时间需要填写整数", :only_integer => true
#  validates_inclusion_of    :new_half_match_length, :in => 0..60, :message => "半场时间必须在1小时之内"
#  validates_inclusion_of    :new_rest_length, :in => 0..60, :message => "中场休息时间必须在1小时之内"
  
  validates_inclusion_of :new_match_type, :in => MATCH_TYPES, :message => "不要自己构造表单提交..."
  validates_inclusion_of :new_size, :in => MATCH_SIZES, :message => "不要自己构造表单提交..."
  validates_inclusion_of :new_win_rule, :in => WIN_RULES, :message => "不要自己构造表单提交..."

  validates_length_of :new_description, :maximum =>MAX_DESCRIPTION_LENGTH, :message => "比赛描述最长可以填#{MAX_DESCRIPTION_LENGTH}个字"
  validates_length_of :guest_team_message, :host_team_message, 
    :maximum =>MAX_TEAM_MESSAGE_LENGTH, :message => "留言最长可以填#{MAX_TEAM_MESSAGE_LENGTH}个字"

  def validate
    st = new_start_time.respond_to?(:to_datetime) ? new_start_time.to_datetime : new_start_time
    et = st.since(60 * (self.new_half_match_length * 2 + self.new_rest_length))
    et = et.respond_to?(:to_datetime) ? et.to_datetime : et
    errors.add(:start_time, "比赛开始时间必须大于当前时间") if st < DateTime.now
    errors.add_to_base("比赛最长不能超过1天") if (et - st) > 1
  end
  
  def before_validation
    self.host_team_message = "" if self.host_team_message.nil?
    self.guest_team_message = "" if self.guest_team_message.nil?
    self.new_description = ""  if self.new_description.nil?
    self.new_match_type = 1 if self.new_match_type.nil?
    self.new_size = 5 if self.new_size.nil?
    self.new_win_rule = 1 if self.new_win_rule.nil?
    self.new_start_time = Time.now.tomorrow if self.new_start_time.nil?
    self.new_half_match_length = 45 if self.new_half_match_length.nil?
    self.new_rest_length= 15 if self.new_rest_length.nil?
    self.new_location = self.new_football_ground.name if self.new_football_ground!=nil    
    
    attribute_slice(:new_description, MAX_DESCRIPTION_LENGTH)
    attribute_slice(:host_team_message, MAX_TEAM_MESSAGE_LENGTH)
    attribute_slice(:guest_team_message, MAX_TEAM_MESSAGE_LENGTH)
  end    
  
  def save_last_info!
    self.attributes.each do |a|
      if a[0][0..3] == "new_"
        self[a[0][4..-1].to_sym] = a[1]
      end
    end
  end
  
  def is_a_new_invitation?
    self.created_at == self.updated_at
  end
  
  def has_been_modified?(params)
    match_inv = MatchInvitation.new(params)
    self.attributes.each do |a|
      if a[0][0..3] == "new_"
        if (a[1] != match_inv[a[0].to_sym]) && (params[a[0].to_sym] != nil)
          return true
        end
      end
    end
    return false
  end

  def has_attribute_been_modified?(attribute_name)
    if attribute_name == :football_ground_id || attribute_name == :location
      if football_ground_id.nil? && location.nil?
        return false
      elsif (new_football_ground_id.nil? && !football_ground_id.nil?) ||
        (!new_football_ground_id.nil? && football_ground_id.nil?)
        return true
      elsif !new_football_ground_id.nil? && !football_ground_id.nil?
        return new_football_ground_id != football_ground_id
      else
        return new_location != location
      end
    end
    return (!self[attribute_name].nil?) &&
           (self[attribute_name] != self[("new_"+attribute_name.to_s).to_sym])
  end
  
  def outdated?
    new_start_time < Time.now
  end
  
  def before_create
    Team.update_all('match_invitations_count=match_invitations_count+1', ['id = ?', self.guest_team_id])
  end
  
  def before_update
    return if !self.column_changed?(:edit_by_host_team)
    Team.update_all('match_invitations_count=match_invitations_count+1', ['id = ?', edit_by_host_team ? self.host_team_id : self.guest_team_id])
    Team.update_all('match_invitations_count=match_invitations_count-1', ['id = ?', !edit_by_host_team ? self.host_team_id : self.guest_team_id])
  end
  
  def before_destroy
    Team.update_all('match_invitations_count=match_invitations_count-1', ['id = ?', edit_by_host_team ? self.host_team_id : self.guest_team_id])
  end
end
