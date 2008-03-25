class Play < ActiveRecord::Base 
#  validates_presence_of :start_time, :location
  belongs_to :football_ground

  has_many :play_joins,
            :dependent => :destroy  
  has_many :users, :through=>:play_joins  

  def before_validation
    self.location = self.football_ground.name if self.football_ground!=nil
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
