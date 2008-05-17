class Watch < ActiveRecord::Base
  
  MAX_DESCRIPTION_LENGTH = 3000
  MAX_LOCATION_LENGTH = 100  
  
  belongs_to :official_match
  belongs_to :admin, :class_name=>"User", :foreign_key=>"user_id"
  
  attr_protected :official_match_id, :user_id

  has_many :watch_joins, :dependent => :destroy  

  has_many :watch_join_broadcasts, :foreign_key=>"activity_id", :dependent => :destroy  
  
  validates_presence_of :official_match_id, :message=>"我们还不知道你想看哪场球啊..."
  validates_presence_of :start_time, :message=>"忘了填什么时候看球吧？"
  validates_length_of :location, :maximum => MAX_LOCATION_LENGTH, :message=>"场地名称最长可以填#{MAX_LOCATION_LENGTH}个字"
  validates_length_of :description, :maximum =>MAX_DESCRIPTION_LENGTH, :allow_nil => true  

  def can_be_joined_by?(user)
    user_id = case user
    when User
      user.id
    else 
      user
    end
    WatchJoin.find_by_user_id_and_watch_id(user_id,self.id) == nil
  end

  def can_be_quited_by?(user)
    user_id = case user
    when User
      user.id
    else 
      user
    end
    WatchJoin.find_by_user_id_and_watch_id(user_id,self.id) != nil
  end

  def after_destroy
    OfficialMatch.update_all('watch_count=watch_count-1', ['id = ?', self.official_match_id])        
  end

  def after_create
    OfficialMatch.update_all('watch_count=watch_count+1', ['id = ?', self.official_match_id]) 
  end  

end
