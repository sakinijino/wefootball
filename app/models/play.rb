class Play < ActiveRecord::Base 
#  validates_presence_of :start_time, :location
  belongs_to :football_ground

  has_many :play_joins,
            :dependent => :destroy  
  has_many :users, :through=>:play_joins  

  validates_presence_of     :location, :message => "请填写地点"
  validates_length_of        :location,    :maximum => 300
  
  def validate
    st = start_time.respond_to?(:to_datetime) ? start_time.to_datetime : start_time
    et = end_time.respond_to?(:to_datetime) ? end_time.to_datetime : end_time
    errors.add(:start_time, "开始时间必须大于当前时间") if st < DateTime.now
    errors.add(:end_time, "至少要进行15分钟") if (et - st)*24*60 < 15
  end
  
  def before_validation
    self.location = self.football_ground.name if self.football_ground!=nil
    self.start_time = DateTime.now.tomorrow if self.start_time==nil
    self.end_time = self.start_time.since(3600) if self.end_time==nil
  end
  
  def is_before_play?
    Time.now < self.start_time
  end
  
  def can_be_joined_by?(user_id)
    if self.is_before_play? && !PlayJoin.find_by_user_id_and_play_id(user_id,self.id)
      return true
    else
      return false
    end
  end

  def can_be_unjoined_by?(user_id)
    if self.is_before_play? && PlayJoin.find_by_user_id_and_play_id(user_id,self.id)
      return true
    else
      return false
    end    
  end
  
end
