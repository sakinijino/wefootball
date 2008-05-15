require File.dirname(__FILE__) + '/../test_helper'

class OfficialMatchesControllerTest < ActionController::TestCase
  def test_not_editor
    login_as :aaron
    get :new
    assert_fake_redirected
    get :edit, :id=>official_matches(:one)
    assert_fake_redirected
    post :create, :official_match => {:official_host_team_id => official_teams(:inter), 
      :official_guest_team_id => official_teams(:milan), :location=>'wusi'}
    assert_fake_redirected
    post :update, :id=>official_matches(:one)
    assert_fake_redirected
  end

  def test_should_create_official_match
    login_as :saki
    assert_difference('OfficialMatch.count') do
    assert_difference('users(:saki).official_matches.reload.size') do
      post :create, :official_match => {:host_official_team_id => official_teams(:inter).id, 
        :guest_official_team_id => official_teams(:milan).id, :location=>'wusi'}
    end
    end
    assert_redirected_to official_match_path(assigns(:official_match))
    assert_equal official_teams(:inter).id, assigns(:official_match).host_official_team_id
    assert_equal official_teams(:milan).id, assigns(:official_match).guest_official_team_id
    assert_equal 'wusi', assigns(:official_match).location
  end

  def test_should_update_official_match
    login_as :saki
    put :update, :id => official_matches(:one).id, :official_match => {:host_official_team_id => official_teams(:milan).id, 
        :guest_official_team_id => official_teams(:inter).id, :location=>'wusi'}
    assert_redirected_to official_match_path(assigns(:official_match))
    official_matches(:one).reload
    assert_equal official_teams(:milan).id, official_matches(:one).host_official_team_id
    assert_equal official_teams(:inter).id, official_matches(:one).guest_official_team_id
    assert_equal 'wusi', official_matches(:one).location
  end
end
