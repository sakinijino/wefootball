class TeamJoinRequest < ActiveRecord::Base
  belongs_to :user
  belongs_to :team
  
  validates_length_of       :message, :maximum => 300
  
  def before_create
    self.apply_date = Date.today
  end
end
