require File.dirname(__FILE__) + '/../test_helper'

class MatchJoinsControllerTest < ActionController::TestCase
  #~ def test_should_get_index
    #~ get :index
    #~ assert_response :success
    #~ assert_not_nil assigns(:match_joins)
  #~ end

  #~ def test_should_get_new
    #~ get :new
    #~ assert_response :success
  #~ end

  #~ def test_should_create_match_join
    #~ assert_difference('MatchJoin.count') do
      #~ post :create, :match_join => { }
    #~ end

    #~ assert_redirected_to match_join_path(assigns(:match_join))
  #~ end

  #~ def test_should_show_match_join
    #~ get :show, :id => match_joins(:one).id
    #~ assert_response :success
  #~ end

  #~ def test_should_get_edit
    #~ get :edit, :id => match_joins(:one).id
    #~ assert_response :success
  #~ end

  #~ def test_should_update_match_join
    #~ put :update, :id => match_joins(:one).id, :match_join => { }
    #~ assert_redirected_to match_join_path(assigns(:match_join))
  #~ end

  #~ def test_should_destroy_match_join
    #~ assert_difference('MatchJoin.count', -1) do
      #~ delete :destroy, :id => match_joins(:one).id
    #~ end

    #~ assert_redirected_to match_joins_path
  #~ end
end
