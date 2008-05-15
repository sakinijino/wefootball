class MatchReviewsController < ApplicationController
  before_filter :login_required, :except => [:index, :show]
  
  REPLIES_PER_PAGE = 100
  SUMMARY_LENGTH = 200
  
  def index
    if (params[:sided_match_id])
      @match = SidedMatch.find params[:sided_match_id]
    elsif (params[:official_match_id])
      @match = OfficialMatch.find params[:official_match_id]
    elsif (params[:match_id])
      @match = Match.find params[:match_id]
    elsif (params[:user_id])
      @user = User.find params[:user_id]
    else
      fake_params_redirect
      return
    end
    
    @title = "#{@match ? @match.to_s : @user.nickname}的球评"
    @reviews = @match ? 
      @match.match_reviews.paginate(:page => params[:page], :per_page => 15) :
      @user.match_reviews.paginate(:page => params[:page], :per_page => 15)
    render :layout => match_layout
  end
  
  def show
    @match_review = MatchReview.find(params[:id])
    
    @replies = @match_review.match_review_replies.paginate(:page => params[:page], :per_page => REPLIES_PER_PAGE)
    @can_reply = logged_in?
    @match = @match_review.match
    
    @title = "#{@match_review.title}"
    render :layout => default_layout
  end

  def new
    if (params[:sided_match_id])
      @match = SidedMatch.find params[:sided_match_id]
      @match_reviews_url = sided_match_match_reviews_path(@match)
    elsif (params[:official_match_id])
      @match = OfficialMatch.find params[:official_match_id]
      @match_reviews_url = official_match_match_reviews_path(@match)
    elsif (params[:match_id])
      @match = Match.find params[:match_id]
      @match_reviews_url = match_match_reviews_path(@match)
    else
      fake_params_redirect
      return
    end
    
    @title = "评论#{@match.to_s}的比赛"
    @match_review = MatchReview.new
    render :layout => match_layout
  end
  
  def edit
    @match_review = MatchReview.find(params[:id])
    if !@match_review.can_be_modified_by?(current_user)
      fake_params_redirect
    else
      @match = @match_review.match
      @title = "修改球评"
      render :layout => default_layout
    end
  end

  def create
    if (params[:sided_match_id])
      @match = SidedMatch.find params[:sided_match_id]
      @match_review = SidedMatchReview.new(params[:match_review])
    elsif (params[:official_match_id])
      @match = OfficialMatch.find params[:official_match_id]
      @match_review = OfficialMatchReview.new(params[:match_review])
    elsif (params[:match_id])
      @match = Match.find params[:match_id]
      @match_review = BiMatchReview.new(params[:match_review])
    else
      fake_params_redirect
      return
    end

    @match_review.match = @match
    @match_review.user = current_user
    if @match_review.save
      redirect_to match_review_path(@match_review)
    else
      render :action => "new", :layout => match_layout
    end
  end

  def update
    @match_review = MatchReview.find(params[:id])

    if !@match_review.can_be_modified_by?(current_user)
      fake_params_redirect
    elsif @match_review.update_attributes(params[:match_review])
      redirect_to match_review_path(@match_review)
    else
      @match = @match_review.match
      render :action => "edit", :layout => default_layout
    end
  end

  def destroy
    @match_review = MatchReview.find(params[:id])
    if !@match_review.can_be_destroyed_by?(current_user)
      fake_params_redirect
    else
      @match_review.destroy
      redirect_to @match_review.match
    end
  end
  
  private
  def match_layout
    case @match
    when Match
      "match_layout"
    when SidedMatch
      @team = @match.team
      "team_layout"
    else
      default_layout
    end
  end
end
