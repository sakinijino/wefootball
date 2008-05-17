require File.dirname(__FILE__) + '/../test_helper'

class MatchReviewRecommendationsControllerTest < ActionController::TestCase
  def test_unlogin
    post :create, :match_review_id=>match_reviews(:saki_1).id, :status=>1
    assert_redirected_to new_session_path    
  end
  
  def test_should_create
    login_as :saki
    assert_difference('MatchReviewRecommendation.count',1) do
      post :create, :match_review_id=>match_reviews(:saki_1).id, :status=>1
    end
    assert_equal assigns(:mrr),
      MatchReviewRecommendation.find_by_match_review_id_and_user_id(match_reviews(:saki_1).id,users(:saki).id)
  end
  
  def test_should_not_create
    login_as :saki
    assert_no_difference('MatchReviewRecommendation.count') do
      post :create, :match_review_id=>match_reviews(:saki_1).id, :status=>2
    end
    assert_response 403  
  end
  
  def test_redirect
    login_as :saki
    assert_difference('MatchReviewRecommendation.count',1) do
      post :create, :match_review_id=>match_reviews(:saki_1).id, :status=>1, 
        :back_uri=>'/'
    end
    assert_redirected_to '/'
  end
  
  def test_match_review_count_create_like
    login_as :saki 
    
    mr_id = match_reviews(:saki_1).id
    
    assert_difference('MatchReviewRecommendation.count',1) do
    assert_difference('MatchReview.find(mr_id).like_count', 1) do
    assert_no_difference('MatchReview.find(mr_id).dislike_count') do      
      post :create, :match_review_id=>mr_id, :status=>1
    end
    end
    end  
  end
  
  def test_match_review_count_create_dislike
    login_as :saki 
    
    mr_id = match_reviews(:saki_1).id
    
    assert_difference('MatchReviewRecommendation.count',1) do
    assert_no_difference('MatchReview.find(mr_id).like_count') do
    assert_difference('MatchReview.find(mr_id).dislike_count',1) do      
      post :create, :match_review_id=>mr_id, :status=>0
    end
    end
    end   
  end
  
  def test_match_review_count_update_from_like_to_dislike
    login_as :saki 
    
    mr_id = match_reviews(:saki_1).id 
    post :create, :match_review_id=>mr_id, :status=>1

    assert_no_difference('MatchReviewRecommendation.count') do
    assert_difference('MatchReview.find(mr_id).like_count',-1) do
    assert_difference('MatchReview.find(mr_id).dislike_count',1) do     
      post :create, :match_review_id=>mr_id, :status=>0
    end
    end
    end    
  end
  
  def test_match_review_count_update_from_dislike_to_like
    login_as :saki 
    
    mr_id = match_reviews(:saki_1).id 
    post :create, :match_review_id=>mr_id, :status=>0

    assert_no_difference('MatchReviewRecommendation.count') do
    assert_difference('MatchReview.find(mr_id).like_count',1) do
    assert_difference('MatchReview.find(mr_id).dislike_count',-1) do     
      post :create, :match_review_id=>mr_id, :status=>1
    end
    end
    end    
  end

  def test_match_review_count_update_like_unchanged
    login_as :saki 
    
    mr_id = match_reviews(:saki_1).id 
    post :create, :match_review_id=>mr_id, :status=>1

    assert_no_difference('MatchReviewRecommendation.count') do
    assert_no_difference('MatchReview.find(mr_id).like_count') do
    assert_no_difference('MatchReview.find(mr_id).dislike_count') do     
      post :create, :match_review_id=>mr_id, :status=>1
    end
    end
    end    
  end

  def test_match_review_count_update_dislike_unchanged
    login_as :saki 
    
    mr_id = match_reviews(:saki_1).id 
    post :create, :match_review_id=>mr_id, :status=>0

    assert_no_difference('MatchReviewRecommendation.count') do
    assert_no_difference('MatchReview.find(mr_id).like_count') do
    assert_no_difference('MatchReview.find(mr_id).dislike_count') do     
      post :create, :match_review_id=>mr_id, :status=>0
    end
    end
    end    
  end   
end
