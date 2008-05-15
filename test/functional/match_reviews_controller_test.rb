require File.dirname(__FILE__) + '/../test_helper'

class MatchReviewsControllerTest < ActionController::TestCase
  def test_should_get_official_match_index
    get :index, :official_match_id => official_matches(:one)
    assert_response :success
    assert_equal 1, assigns(:reviews).length
  end
  
  def test_should_get_match_index
    get :index, :match_id => matches(:one)
    assert_response :success
    assert_equal 1, assigns(:reviews).length
  end
  
  def test_should_get_sided_match_index
    get :index, :sided_match_id => sided_matches(:one)
    assert_response :success
    assert_equal 1, assigns(:reviews).length
  end
  
  def test_should_get_user_index
    get :index, :user_id => users(:saki)
    assert_response :success
    assert_equal 3, assigns(:reviews).length
  end

  def test_get_show_can_reply
    login_as :quentin
    get :show, :id => match_reviews(:saki_1).id
    assert_select "#content form[action=#{match_review_match_review_replies_path(assigns(:match_review), :page => 1)}]"
  end
  
  def test_get_show_can_not_reply
    get :show, :id => match_reviews(:saki_1).id
    assert_select "#content form", 0
  end
  
  def test_get_edit_noauth
    login_as :quentin
    get :edit, :id => match_reviews(:saki_1).id
    assert_fake_redirected
  end

  def test_should_create_match_review
    login_as :quentin
    assert_difference('MatchReview.count') do
    assert_difference('BiMatchReview.count') do
    assert_difference('matches(:one).match_reviews.reload.length') do
    assert_difference('users(:quentin).match_reviews.reload.length') do
      post :create, :match_id=>matches(:one).id, :match_review => { :title => 'Test', :content => '123456'*100}
    end
    end
    end
    end
    assert_redirected_to match_review_path(assigns(:match_review))
    
    assert_difference('MatchReview.count') do
    assert_difference('OfficialMatchReview.count') do
    assert_difference('official_matches(:one).match_reviews.reload.length') do
    assert_difference('users(:quentin).match_reviews.reload.length') do
      post :create, :official_match_id=>official_matches(:one).id, :match_review => { :title => 'Test', :content => '123456'*100}
    end
    end
    end
    end
    assert_redirected_to match_review_path(assigns(:match_review))
    
    assert_difference('MatchReview.count') do
    assert_difference('SidedMatchReview.count') do
    assert_difference('sided_matches(:one).match_reviews.reload.length') do
    assert_difference('users(:quentin).match_reviews.reload.length') do
      post :create, :sided_match_id=>sided_matches(:one).id, :match_review => { :title => 'Test', :content => '123456'*100}
    end
    end
    end
    end
    assert_redirected_to match_review_path(assigns(:match_review))
  end
  
  def test_should_update_match_review
    login_as :saki
    put :update, :id => match_reviews(:saki_1).id, :match_review => { :content => '123456'*100 }
    assert_equal '123456'*100, assigns(:match_review).content
    assert_redirected_to match_review_path(assigns(:match_review))
  end
  
  def test_update_noauth
    login_as :quentin
    put :update, :id => match_reviews(:saki_1).id, :match_review => { :content => '123456'*100 }
    assert_fake_redirected
  end

  def test_should_destroy_match_review
    login_as :saki
    assert_difference('MatchReview.count', -1) do
      delete :destroy, :id => match_reviews(:saki_1).id
    end
    assert_redirected_to sided_match_path(sided_matches(:one))
  end
  
  def test_destroy_match_review_unauth
    login_as :aaron
    assert_no_difference('MatchReview.count') do
      delete :destroy, :id => match_reviews(:saki_1).id
    end
    assert_fake_redirected
  end
end
