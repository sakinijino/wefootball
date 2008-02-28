require File.dirname(__FILE__) + '/../test_helper'

class TeamTest < ActiveSupport::TestCase
  def test_image_path
    assert_equal "/images/teams/t00000001.jpg", teams(:inter).image
    assert_equal "/images/default_team.jpg", teams(:milan).image
  end
  
  def test_recent_trainings
    t = Team.find(1)
    assert_equal 2, t.trainings.recent(nil, DateTime.new(2008, 1, 19)).length
    assert_equal 1, t.trainings.recent(1, DateTime.new(2008, 1, 19)).length
    assert_equal 1, t.trainings.recent(nil, DateTime.new(2008, 1, 21)).length
  end
  
  def test_users
    assert_equal 2,  teams(:inter).users.length
    assert_equal 2,  teams(:milan).users.length
    assert_equal 2,  teams(:inter).users.admin.length
    assert_equal 1,  teams(:milan).users.admin.length
  end
  
  def test_destroy
    assert_difference 'TeamImage.count', -1 do
    assert_difference 'Training.count', -2 do
    assert_difference 'UserTeam.count', -2 do
    assert_difference 'TeamJoinRequest.count', -4 do
      inter = teams(:inter)
      inter.destroy
    end
    end
    end
    end
  end
  
  def test_search
    Team.create({:name => 'Beijing Guo An', :shortname=>'BGA'})
    Team.create({:name => 'Beijing Kuan Li', :shortname=>'BKL'})
    teams = Team.find_by_contents("BGA")
    assert 1, teams.length
    teams = Team.find_by_contents("Beijing")
    assert 2, teams.length
  end
end