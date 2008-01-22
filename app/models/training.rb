class Training < ActiveRecord::Base
  belongs_to :team
  
  has_many :training_joins,
            :dependent => :destroy
  has_many :users, :through=>:training_joins
  
  validates_length_of        :location,    :maximum => 300
  validates_length_of        :summary,    :maximum => 700, :allow_nil=>true
  
  def before_create
    self.summary = '' if self.summary==nil
    self.start_time = DateTime.now if self.start_time==nil
    self.end_time = DateTime.now if self.end_time==nil
  end
  
  def can_join?(user)
    self.team.users.include?(user) && !already_join?(user)
  end
  
  def already_join?(user)
    self.users.include?(user)
  end
end
