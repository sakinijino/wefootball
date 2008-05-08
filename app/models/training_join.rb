class TrainingJoin < ActiveRecord::Base
  include AttributesTracking
  
  belongs_to :user
  belongs_to :training
  
  UNDETERMINED = 0
  JOIN = 1
  
  attr_protected :status
  
  def self.create_joins(training)
    team = training.team
    team.users.each do |user|
      tj = TrainingJoin.new
      tj.training_id = training.id
      tj.user_id = user.id
      tj.status = UNDETERMINED
      tj.save!
    end
  end
end
