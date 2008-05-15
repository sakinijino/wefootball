class Watch < ActiveRecord::Base
  
  MAX_DESCRIPTION_LENGTH = 3000
  MAX_LOCATION_LENGTH = 100  
  
  belongs_to :official_match
  belongs_to :admin, :class_name=>"User", :foreign_key=>"user_id"
  
  attr_protected :official_match_id, :user_id

  has_many :watch_joins, :dependent => :destroy  

  validates_presence_of :start_time, :message=>"忘了填什么时候看球吧？"
  validates_length_of :location, :maximum => MAX_LOCATION_LENGTH, :message=>"场地名称最长可以填#{MAX_LOCATION_LENGTH}个字"
  validates_length_of :description, :maximum =>MAX_DESCRIPTION_LENGTH, :allow_nil => true  
end
