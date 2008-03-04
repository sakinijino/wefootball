class Training < ActiveRecord::Base
  belongs_to :team
  
  has_many :training_joins,
            :dependent => :destroy
  has_many :users, :through=>:training_joins
  
  has_many :posts, :dependent => :destroy, :order => "updated_at desc" do
    def public
      find :all, :conditions => ['is_private = ?', false]
    end
  end
  
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
    user_id = case user
    when User
      user.id
    else
      user
    end
    (TrainingJoin.count :conditions => ['user_id = ? and training_id = ?', user_id, self.id]) > 0
    #self.users.include?(user)
  end
end
