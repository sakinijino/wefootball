class MatchReviewReply < ActiveRecord::Base
  belongs_to :user
  belongs_to :match_review, :counter_cache => true
  
  validates_length_of :content, :minimum =>2, :message => "内容太短了, 最少也写2个字吧"
  
  attr_accessible :content
  
  def can_be_destroyed_by?(user)
    self.user_id == get_user_id(user) || self.match_review.user_id == get_user_id(user)
  end

private
  def get_user_id(user)
    case user
    when User
      user.id
    else
      user
    end
  end
end
