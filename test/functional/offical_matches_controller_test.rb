require File.dirname(__FILE__) + '/../test_helper'

class OfficalMatchesControllerTest < ActionController::TestCase
  def test_not_editor
    login_as :aaron
    get :new
    assert_fake_redirected
    get :edit, :id=>offical_matches(:one)
    assert_fake_redirected
    post :create, :offical_match => {:offical_host_team_id => offical_teams(:inter), 
      :offical_guest_team_id => offical_teams(:milan), :location=>'wusi'}
    assert_fake_redirected
    post :update, :id=>offical_matches(:one)
    assert_fake_redirected
  end

  def test_should_create_offical_match
    login_as :saki
    assert_difference('OfficalMatch.count') do
    assert_difference('users(:saki).offical_matches.reload.size') do
      post :create, :offical_match => {:host_offical_team_id => offical_teams(:inter).id, 
        :guest_offical_team_id => offical_teams(:milan).id, :location=>'wusi'}
    end
    end
    assert_redirected_to offical_match_path(assigns(:offical_match))
    assert_equal offical_teams(:inter).id, assigns(:offical_match).host_offical_team_id
    assert_equal offical_teams(:milan).id, assigns(:offical_match).guest_offical_team_id
    assert_equal 'wusi', assigns(:offical_match).location
  end

  def test_should_update_offical_match
    login_as :saki
    put :update, :id => offical_matches(:one).id, :offical_match => {:host_offical_team_id => offical_teams(:milan).id, 
        :guest_offical_team_id => offical_teams(:inter).id, :location=>'wusi'}
    assert_redirected_to offical_match_path(assigns(:offical_match))
    offical_matches(:one).reload
    assert_equal offical_teams(:milan).id, offical_matches(:one).host_offical_team_id
    assert_equal offical_teams(:inter).id, offical_matches(:one).guest_offical_team_id
    assert_equal 'wusi', offical_matches(:one).location
  end
end
