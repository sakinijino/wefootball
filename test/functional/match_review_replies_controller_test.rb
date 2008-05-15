require File.dirname(__FILE__) + '/../test_helper'

class MatchReviewRepliesControllerTest < ActionController::TestCase
  def test_should_create_reply
    login_as :quentin
    MatchReview.find(match_reviews(:saki_1).id).match_review_replies(:refresh).size
    assert_difference('MatchReview.find(match_reviews(:saki_1).id).match_review_replies.size') do
      post :create, :match_review_id => match_reviews(:saki_1).id, :reply => {:content=>"1234567890"}
    end
    assert_redirected_to match_review_path(match_reviews(:saki_1))
    
    assert_difference('MatchReview.find(match_reviews(:saki_2).id).match_review_replies.size') do
      post :create, :match_review_id => match_reviews(:saki_2).id, :reply => {:content=>"1234567890"}
    end
    assert_redirected_to match_review_path(match_reviews(:saki_2))
    
    assert_difference('MatchReview.find(match_reviews(:saki_3).id).match_review_replies.size') do
      post :create, :match_review_id => match_reviews(:saki_3).id, :reply => {:content=>"1234567890"}
    end
    assert_redirected_to match_review_path(match_reviews(:saki_3))
  end
  
  def test_create_reply_error
    login_as :quentin
    MatchReview.find(match_reviews(:saki_1).id).match_review_replies(:refresh).size
    assert_no_difference('MatchReview.find(match_reviews(:saki_1).id).match_review_replies.size') do
      post :create, :match_review_id => match_reviews(:saki_1).id, :reply => {:content=>""}
      assert_equal 1, assigns(:replies).length
    end
    assert_template "match_reviews/show"
  end
  
  def test_create_reply_no_auth
    MatchReview.find(match_reviews(:saki_1).id).match_review_replies(:refresh).size
    assert_no_difference('MatchReview.find(match_reviews(:saki_1).id).match_review_replies.size') do
      post :create, :match_review_id => match_reviews(:saki_1).id, :reply => {:content=>""}
    end
    assert_redirected_to new_session_path
  end

  def test_should_destroy_reply
    login_as :saki
    MatchReview.find(match_reviews(:saki_1).id).match_review_replies(:refresh).size
    assert_difference('MatchReview.find(match_reviews(:saki_1).id).match_review_replies.size', -1) do
      delete :destroy, :id => match_review_replies(:quentin_1_reply).id
    end
    assert_redirected_to match_review_path(match_reviews(:saki_1))
  end
  
  def test_should_destroy_reply_no_auth
    login_as :aaron
    MatchReview.find(match_reviews(:saki_1).id).match_review_replies(:refresh).size
    assert_no_difference('MatchReview.find(match_reviews(:saki_1).id).match_review_replies.size') do
      delete :destroy, :id => match_review_replies(:quentin_1_reply).id
    end
    assert_fake_redirected
  end
end
