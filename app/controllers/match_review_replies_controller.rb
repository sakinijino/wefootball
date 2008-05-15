class MatchReviewRepliesController < ApplicationController
  before_filter :login_required
  
  def create
    @match_review = MatchReview.find(params[:match_review_id])
    
    @reply = MatchReviewReply.new(params[:reply])
    @reply.user = current_user
    @match_review.match_review_replies << @reply
    if @reply.save
      redirect_to match_review_path(@match_review)
    else
      @replies = @match_review.match_review_replies.paginate(:page => params[:page], :per_page => MatchReviewsController::REPLIES_PER_PAGE)
      @can_reply = logged_in?
      @match = @match_review.match
      @title = "#{@match_review.title}"
      render :template => "match_reviews/show", :layout => default_layout
    end
  end

  def destroy
    @reply = MatchReviewReply.find(params[:id])
    if (!@reply.can_be_destroyed_by?(current_user))
      fake_params_redirect
    else
      @reply.match_review.match_review_replies.delete(@reply)
      redirect_to match_review_path(@reply.match_review)
    end
  end
end
