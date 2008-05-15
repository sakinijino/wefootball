class SidedMatch < ActiveRecord::Base
  include ModelHelper
  
  MAX_DESCRIPTION_LENGTH = 3000
  MAX_LOCATION_LENGTH = 100   
  
  MATCH_TYPES = [1,2]
  MATCH_SIZES = (5..11).to_a
  WIN_RULES = [1,2,3]  
  SITUATIONS = (1..8).to_a  
  
  belongs_to :football_ground
  belongs_to :team, :foreign_key => 'host_team_id'
  
  has_many :sided_match_joins,
            :dependent => :destroy,
            :foreign_key => :match_id
          
  has_many :users, :through=>:sided_match_joins do
    def joined(options={})
      q = {:conditions => ['status = ?', SidedMatchJoin::JOIN]}.merge(options)
      options.has_key?(:page) ? paginate(:all, q) : find(:all, q)
    end
    def undetermined(options={})
      q = {:conditions => ['status = ?', SidedMatchJoin::UNDETERMINED]}.merge(options)
      options.has_key?(:page) ? paginate(:all, q) : find(:all, q)      
    end
  end
  
  has_many :posts, :dependent => :nullify, :order => "updated_at desc" do
    def public(options={})
      q = {:conditions => ['is_private = ?', false]}.merge(options)
      options.has_key?(:page) ? paginate(:all, q) : find(:all, q)
    end
  end
  
  has_many :sided_match_creation_broadcasts, :foreign_key=>"activity_id", :dependent => :destroy
  has_many :sided_match_join_broadcasts, :foreign_key=>"activity_id", :dependent => :destroy
  
  has_many :match_reviews, :foreign_key=>"match_id", :class_name=>"SidedMatchReview", :dependent => :destroy
            
  attr_protected :host_team_id
  
  validates_presence_of     :start_time, :message => "请填写比赛开始时间"
  
  validates_presence_of     :location, :message => "请填写或选择比赛场地"
  validates_length_of :location, :maximum => MAX_LOCATION_LENGTH, :message=>"场地名称最长可以填#{MAX_LOCATION_LENGTH}个字"
  
  validates_presence_of     :guest_team_name, :message => "请填写对方球队名称"
  
  validates_length_of        :guest_team_name, :maximum => 15, :message => "球队名称最长可以填15个字"
  validates_inclusion_of   :situation, :in => SITUATIONS, :allow_nil=>true, :message => "不要自己构造表单提交..."
  validates_numericality_of :host_team_goal, :guest_team_goal, :allow_nil=>true, :message => "进球数需要填写整数", :only_integer => true
  validates_inclusion_of    :host_team_goal, :guest_team_goal, 
      :allow_nil=>true, :in => 0..99, :message => "真的进了这么多球吗？"
  
  validates_numericality_of :half_match_length, :message => "半场时间需要填写整数", :only_integer => true
  validates_numericality_of :rest_length, :message => "中场休息时间需要填写整数", :only_integer => true
#  validates_inclusion_of    :half_match_length, :in => 0..60, :message => "半场时间必须在1小时之内"
#  validates_inclusion_of    :rest_length, :in => 0..60, :message => "中场休息时间必须在1小时之内"
  
  validates_inclusion_of :match_type, :in => MATCH_TYPES, :message => "不要自己构造表单提交..."
  validates_inclusion_of :size, :in => MATCH_SIZES, :message => "不要自己构造表单提交..."
  validates_inclusion_of :win_rule, :in => WIN_RULES , :message => "不要自己构造表单提交..."

  validates_length_of  :description, :maximum =>MAX_DESCRIPTION_LENGTH, :allow_nil => true, :message => "比赛描述最长可以填#{MAX_DESCRIPTION_LENGTH}个字"
   
  belongs_to :host_team, :class_name=>"Team", :foreign_key=>"host_team_id"
  
  def validate
    self.end_time = self.start_time.since(60 * self.full_match_length)
    st = start_time.respond_to?(:to_datetime) ? start_time.to_datetime : start_time
    et = end_time.respond_to?(:to_datetime) ? end_time.to_datetime : self.end_time
    errors.add_to_base("比赛最长不能超过1天") if (et - st) > 1
  end
  
  def before_save
    self.end_time = self.start_time.since(60 * self.full_match_length) if self.end_time == nil
  end
  
  def full_match_length
    2*self.half_match_length + self.rest_length
  end
  
  def before_validation
    if !(self.guest_team_goal.blank? && self.host_team_goal.blank?)
      self.situation = Match.calculate_situation(self.host_team_goal,self.guest_team_goal )
    end    
    self.description = "" if self.description.nil?
    self.match_type = 1 if self.match_type.nil?
    self.size = 5 if self.size.nil?
    self.win_rule = 1 if self.win_rule.nil?
    self.start_time = DateTime.now.tomorrow if self.start_time==nil
    self.half_match_length = 45 if self.half_match_length==nil
    self.rest_length = 15 if self.rest_length==nil
    self.location = self.football_ground.name if self.football_ground!=nil     
    attribute_slice(:description, MAX_DESCRIPTION_LENGTH)
  end

  def is_before_match?
    return Time.now < self.start_time
  end
  
  def is_after_match?
    return Time.now > self.end_time
  end
  
  def can_be_created_by?(user)
    user.is_team_admin_of?(self.host_team_id)
  end

  def can_be_edited_by?(user)
    #is_before_match? && user.is_team_admin_of?(self.host_team_id)
    user.is_team_admin_of?(self.host_team_id)
  end  
  
  def can_be_edited_result_by?(user)
    is_after_match? && user.is_team_admin_of?(self.host_team_id)
  end
  
  def can_be_edited_formation_by?(user)
    user.is_team_admin_of?(self.host_team_id)
  end

  def can_be_destroyed_by?(user)
    user.is_team_admin_of?(self.host_team_id)
  end
  
  def can_be_joined_by?(user)
    team_id = self.host_team_id
    #is_before_match? && user.is_team_member_of?(team_id) && !has_joined_member?(user)
    user.is_team_member_of?(team_id) && !has_joined_member?(user)
  end
  
  def can_be_quited_by?(user)
    team_id = self.host_team_id
    #is_before_match? && user.is_team_member_of?(team_id) && has_member?(user)
    user.is_team_member_of?(team_id) && has_member?(user)
  end
  
  def has_joined_member?(user)
    tj = has_member?(user)
    tj!=nil && tj.status == SidedMatchJoin::JOIN    
  end
  
  def has_member?(user)
    user_id = case user
    when User
      user.id
    else
      user
    end
    SidedMatchJoin.find :first, :conditions => ['user_id = ? and match_id = ?', user_id, self.id]
  end
  
  def to_s
    "#{self.team.shortname} V.S. #{self.guest_team_name}"
  end
end
