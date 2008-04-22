class Play < ActiveRecord::Base 
  belongs_to :football_ground

  has_many :play_joins,
            :dependent => :destroy
          
  has_many :users, :through => :play_joins  

  validates_presence_of     :location, :message => "请填写或选择场地"
  validates_length_of        :location,    :maximum => 100, :message=>"场地名称最长可以填100个字"
  
  def validate
    st = start_time.respond_to?(:to_datetime) ? start_time.to_datetime : start_time
    et = end_time.respond_to?(:to_datetime) ? end_time.to_datetime : end_time
    errors.add(:start_time, "开始时间必须大于当前时间") if st < DateTime.now
    time_span = (et - st)*24*60
    if time_span <= 0
      errors.add(:end_time, "开始时间必须小于结束时间")
    elsif time_span < 15
      errors.add(:end_time, "至少要进行15分钟") 
    end
    errors.add(:end_time, "随便踢踢最长不能超过1天") if (et - st) > 1
  end
  
  def before_validation
    self.location = self.football_ground.name if self.football_ground!=nil
    self.start_time = 1.hour.since if self.start_time==nil
    self.end_time = self.start_time.since(3600) if self.end_time==nil
  end
  
  def is_before_play?
    Time.now < self.start_time
  end
  
  def has_member?(user)
    user_id = case user
    when User
      user.id
    else 
      user
    end
    PlayJoin.find_by_user_id_and_play_id(user_id,self.id) != nil
  end
  
  def can_be_joined_by?(user)
    user_id = case user
    when User
      user.id
    else 
      user
    end
    #self.is_before_play? && PlayJoin.find_by_user_id_and_play_id(user_id,self.id) == nil
    PlayJoin.find_by_user_id_and_play_id(user_id,self.id) == nil
  end

  def can_be_quited_by?(user)
    user_id = case user
    when User
      user.id
    else 
      user
    end
    #self.is_before_play? && PlayJoin.find_by_user_id_and_play_id(user_id,self.id) != nil
    PlayJoin.find_by_user_id_and_play_id(user_id,self.id) != nil
  end
  
end
