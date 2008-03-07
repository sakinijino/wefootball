require File.dirname(__FILE__) + '/../test_helper'

class TeamTest < ActiveSupport::TestCase
  
  def test_city_text
    u = teams(:inter)
    u.city = 0
    assert_nil u.city_text
    u.city = 1
    assert_equal ProvinceCity::LIST[1], u.city_text
  end
  
  def test_image_path
    assert_equal "/images/teams/t00000001.not_image", teams(:inter).image
    assert_equal "/images/default_team.jpg", teams(:milan).image
  end
  
  def test_public_posts
    t = Team.find(1)
    assert_equal 4, t.posts.length
    assert_equal 2, t.posts.public.length
  end
  
  def test_before_validation
    teams(:inter).update_attributes({:name => 'nickname'*50, 
        :shortname => 'favorite_star'*50, 
        :style => 'favorite_team'*50, 
        :summary => 'summary'*1000 })
    assert teams(:inter).valid?
    assert_equal 50, teams(:inter).name.length
    assert_equal 15, teams(:inter).shortname.length
    assert_equal 50, teams(:inter).style.length
    assert_equal 3000, teams(:inter).summary.length
  end
  
  def test_trainings_calendar
    t = Team.find(1)
    assert_equal 2, t.trainings.recent(nil, DateTime.new(2008, 1, 19)).length
    assert_equal 1, t.trainings.recent(1, DateTime.new(2008, 1, 19)).length
    assert_equal 1, t.trainings.recent(nil, DateTime.new(2008, 1, 21)).length
    
    Training.destroy_all
    assert_equal 0, Training.count
    td = Time.now.next_month.next_month.monday.tomorrow.tomorrow
    create_training(td, 1)
    
    create_training(td.at_midnight.ago(7200).since(1), 1)
    create_training(td.monday.ago(7200).since(1), 1)
    create_training(td.at_beginning_of_month.ago(7200).since(1), 1)
    
    create_training(td.at_midnight.tomorrow.ago(1), 1)
    create_training(td.monday.next_week.ago(1), 1)
    create_training(td.at_beginning_of_month.next_month.ago(1), 1)
    
    create_training(td.at_midnight.ago(7200), 1)
    create_training(td.monday.ago(7200), 1)
    create_training(td.at_beginning_of_month.ago(7200), 1)
    
    create_training(td.at_midnight.tomorrow, 1)
    create_training(td.monday.next_week, 1)
    create_training(td.at_beginning_of_month.next_month, 1)
    
    assert_equal 3, t.trainings.in_later_hours(24, td.at_midnight.ago(7200)).length
    assert_equal 3, t.trainings.in_a_day(td).length
    assert_equal 7, t.trainings.in_a_week(td).length
    assert_equal 11, t.trainings.in_a_month(td).length
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
    assert_difference 'Post.count', -4 do
      inter = teams(:inter)
      inter.destroy
    end
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
  
  private
  def create_training(start_time, team_id)
    t = Training.new(:start_time => start_time, :end_time => start_time.since(7200), :location => 'Beijing')
    t.team_id = team_id
    t.save
  end
end