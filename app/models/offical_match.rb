class OfficalMatch < ActiveRecord::Base
  include ModelHelper
  
  MAX_DESCRIPTION_LENGTH = 3000
  MAX_LOCATION_LENGTH = 100
  
  belongs_to :user
  
  belongs_to :host_team, :class_name=>"OfficalTeam", :foreign_key=>"host_offical_team_id"
  belongs_to :guest_team, :class_name=>"OfficalTeam", :foreign_key=>"guest_offical_team_id"
  
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
end
