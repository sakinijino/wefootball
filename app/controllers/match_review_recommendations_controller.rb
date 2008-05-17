class MatchReviewRecommendationsController < ApplicationController
  before_filter :login_required
  
  def create
    @mr = MatchReview.find(params[:match_review_id])
    @mrr = MatchReviewRecommendation.find_or_initialize_by_match_review_id_and_user_id(@mr.id, current_user.id)
    @mrr.status = params[:status]
    @mrr.save!
    redirect_with_back_uri_or_default(match_review_path(@mr))
    rescue ActiveRecord::RecordInvalid => e
      fake_params_redirect   
  end
  
end
