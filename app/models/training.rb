class Training < ActiveRecord::Base
  include ModelHelper
  
  belongs_to :team
  belongs_to :football_ground
  
  has_many :training_joins,
            :dependent => :destroy
  has_many :users, :through=>:training_joins do
    def joined
      find :all, :conditions => ['status = ?', TrainingJoin::JOIN]
    end
    def undetermined
      find :all, :conditions => ['status = ?', TrainingJoin::UNDETERMINED]
    end
  end
  
  has_many :posts, :dependent => :destroy, :order => "updated_at desc" do
    def public
      find :all, :conditions => ['is_private = ?', false]
    end
  end
  
  validates_presence_of     :location, :message => "请填写训练地点"
  validates_length_of        :location,    :maximum => 300
  validates_length_of        :summary,    :maximum => 1000, :allow_nil=>true
  
  attr_protected :team_id
  
  def validate
    st = start_time.respond_to?(:to_datetime) ? start_time.to_datetime : start_time
    et = end_time.respond_to?(:to_datetime) ? end_time.to_datetime : end_time
    errors.add(:start_time, "训练开始时间必须大于当前时间") if st < DateTime.now
    errors.add(:end_time, "训练至少要进行15分钟") if (et - st)*24*60 < 15
    errors.add(:end_time, "训练时间不能超过1天") if (et - st) > 1
  end
  
  def before_validation
    attribute_slice(:summary, 1000)
    self.location = self.football_ground.name if self.football_ground!=nil
    self.start_time = DateTime.now.tomorrow if self.start_time==nil
    self.end_time = self.start_time.since(3600) if self.end_time==nil
  end
  
  def after_create
    TrainingJoin.create_joins(self)
  end
  
  def started?
    Time.now > self.start_time
  end
  
  def finished?
    Time.now > self.end_time
  end
  
  def finished_before_3_days?
    3.days.ago > self.end_time
  end
  
  def can_be_modified_by?(user)
    !started? && user.is_team_admin_of?(self.team_id)
  end
  
  def can_be_destroyed_by?(user)
    !started? && user.is_team_admin_of?(self.team_id)
  end
  
  def can_be_joined_by?(user)
    !finished_before_3_days? && user.is_team_member_of?(self.team_id) && !has_joined_member?(user)
  end
  
  def can_be_quited_by?(user)
    !started? && has_member?(user)
  end
  
  def has_member?(user)
    user_id = case user
    when User
      user.id
    else
      user
    end
    (TrainingJoin.count :conditions => ['user_id = ? and training_id = ?', user_id, self.id]) > 0
  end
  
  def has_joined_member?(user)
    user_id = case user
    when User
      user.id
    else
      user
    end
    (TrainingJoin.count :conditions => ['user_id = ? and training_id = ? and status = ?', user_id, self.id, TrainingJoin::JOIN]) > 0
  end
end
