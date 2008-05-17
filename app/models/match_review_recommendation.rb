class MatchReviewRecommendation < ActiveRecord::Base
  include AttributesTracking    
  
  belongs_to :user
  belongs_to :match_review
  
  validates_inclusion_of :status, :in => [0,1]

  def after_create
    if self.status == 1
      MatchReview.update_all('like_count=like_count+1', ['id = ?', self.match_review_id])
    else
      MatchReview.update_all('dislike_count=dislike_count+1', ['id = ?', self.match_review_id])
    end
  end

  def before_update
    if self.status == 1
      MatchReview.update_all('dislike_count=dislike_count-1,like_count=like_count+1', ['id = ?', self.match_review_id]) if (self.column_changed?(:status))
    else
      MatchReview.update_all('dislike_count=dislike_count+1,like_count=like_count-1', ['id = ?', self.match_review_id]) if (self.column_changed?(:status))      
    end
  end
end
