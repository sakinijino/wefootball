class MatchReview < ActiveRecord::Base
  belongs_to :user

  has_many :match_review_replies, :dependent => :destroy
  
  has_many :match_review_creation_broadcasts, :foreign_key=>"activity_id", :dependent => :destroy
  has_many :match_review_recommendations, :dependent => :destroy
  has_many :match_review_recommendation_broadcasts, :foreign_key=>"activity_id", :dependent => :destroy  
  
  validates_presence_of     :title, :message => "标题不能为空"
  validates_length_of :title, :maximum =>100, :message => "标题最长为100个字"
  validates_length_of :content, :minimum =>50, :message => "内容太短了, 一篇球评最少也写50个字吧"
  
  attr_accessible :title, :content
  
  def can_be_modified_by?(user)
    self.user_id == get_user_id(user)
  end
  
  def can_be_destroyed_by?(user)
    self.user_id == get_user_id(user)
  end
  
  def recommendation_count
    like_count + dislike_count
  end
  
  def like_by?(user)
    mr = match_review_recommendations.find_by_user_id(user)
    mr != nil && mr.status == 1
  end
  
  def dislike_by?(user)
    mr = match_review_recommendations.find_by_user_id(user)
    mr != nil && mr.status == 0
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
