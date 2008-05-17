class Watch < ActiveRecord::Base
  
  MAX_DESCRIPTION_LENGTH = 3000
  MAX_LOCATION_LENGTH = 100  
  
  belongs_to :official_match
  belongs_to :admin, :class_name=>"User", :foreign_key=>"user_id"
  
  attr_protected :official_match_id, :user_id

  has_many :watch_joins, :dependent => :destroy  
  
  has_many :users, :through => :watch_joins

  has_many :watch_join_broadcasts, :foreign_key=>"activity_id", :dependent => :destroy
  
  has_many :posts, :class_name => 'WatchPost', :foreign_key=>"activity_id", :dependent => :destroy, :order => "updated_at desc" do
    def public(options={})
      q = {:conditions => ['is_private = ?', false]}.merge(options)
      options.has_key?(:page) ? paginate(:all, q) : find(:all, q)
    end
  end
  
  validates_presence_of     :location, :message => "请填写看球的地点"
  validates_length_of :location, :maximum => MAX_LOCATION_LENGTH, :message=>"地点最长可以填#{MAX_LOCATION_LENGTH}个字"
  validates_length_of :description, :maximum =>MAX_DESCRIPTION_LENGTH, :allow_nil => true, :message => "描述最长可以填#{MAX_DESCRIPTION_LENGTH}个字"
  
  def validate
    st = start_time.respond_to?(:to_datetime) ? start_time.to_datetime : start_time
    et = end_time.respond_to?(:to_datetime) ? end_time.to_datetime : end_time
    time_span = (et - st)*24*60
    if time_span <= 0
      errors.add(:end_time, "开始时间必须小于结束时间")
    elsif time_span < 15
      errors.add(:end_time, "至少要进行15分钟") 
    end
    errors.add(:end_time, "随便踢踢最长不能超过1天") if (et - st) > 1
  end
  
  def before_validation
    self.start_time = self.official_match.start_time if self.start_time==nil
    self.end_time = self.official_match.end_time if self.end_time==nil
  end

  def started?
    Time.now > self.start_time
  end
  
  def finished?
    return Time.now > self.end_time
  end
  
  def can_be_edited_by?(user)
    user_id = case user
    when User
      user.id
    else 
      user
    end
    self.user_id == user_id
  end  

  def can_be_destroyed_by?(user)
    user_id = case user
    when User
      user.id
    else 
      user
    end
    self.user_id == user_id
  end
  
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
  
  def has_member?(user)
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

  ICON = "watch_icon.gif"
  IMG_TITLE = "看球"
  
  TIME_STATUS_TEXTS = {
    :before => nil,
    :in => '正在进行',
    :after => '结束了'
  }
  
  JOIN_STATUS_TEXTS = {
    :before =>{
      :joined => '我要去',
    },
    :in => {
      :joined => '正在看',
    },
    :after => {
      :joined => '我去了',
    }
  }
  
  JOIN_LINKS_TEXTS = {
    :before =>{
      :joined => ['---', '不去了'],
      :unjoined => ['要去', '---']
    },
    :in =>{
      :joined => ['---', '没去'],
      :unjoined => ['现在去', '---']
    },
    :after =>{
      :joined => ['---', '没去'],
      :unjoined => ['去了', '---']
    }
  }
  
  include ActivityHelper
  
  protected
  def join_key(user, team=nil)
    if has_member?(user)
      :joined
    else
      :unjoined
    end
  end
  
end
