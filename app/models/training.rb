class Training < ActiveRecord::Base
  belongs_to :team
  
  has_many :training_joins,
            :dependent => :destroy
  has_many :users, :through=>:training_joins
  
  validates_length_of        :location,    :maximum => 300
  validates_length_of        :summary,    :maximum => 700, :allow_nil=>true
  
  attr_protected :team_id
  
  def before_create
    self.start_time = DateTime.now if self.start_time==nil
    self.end_time = DateTime.now if self.end_time==nil
  end
  
  def can_be_joined_by?(user)
    user.is_team_member_of?(self.team) && !has_member?(user)
  end
  
  def has_member?(user)
    self.users.include?(user)
  end
end
