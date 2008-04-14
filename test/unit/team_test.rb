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
    assert_equal Team::DEFAULT_IMAGE, teams(:inter).image
    assert_equal Team::DEFAULT_IMAGE, teams(:milan).image
    assert_equal "/images/teams/00/00/00/01.not_image", teams(:inter).image(nil, :refresh)
    assert_equal Team::DEFAULT_IMAGE, teams(:milan).image(nil, :refresh)
    assert_equal "/images/teams/00/00/00/01.not_image", teams(:inter).image
    assert_equal Team::DEFAULT_IMAGE, teams(:milan).image
  end
  
  def test_public_posts
    t = Team.find(1)
    assert_equal 9, t.posts.length
    assert_equal 5, t.posts.public.length
    assert_equal 2, t.posts.public(:limit=>2).length
  end
  
  def test_before_validation
    teams(:inter).update_attributes!({:name => 'nickname'*50, 
        :shortname => 'favorite_star'*50, 
        :style => 'favorite_team'*50, 
        :summary => 'summary'*1000 })
    assert teams(:inter).valid?
    assert_equal 50, teams(:inter).name.length
    assert_equal 15, teams(:inter).shortname.length
    assert_equal 50, teams(:inter).style.length
    assert_equal 3000, teams(:inter).summary.length
  end
  
  def test_trainings_calendar_recent
    t = Team.find(1)
    assert_equal 4, t.trainings.recent(nil, DateTime.new(2008, 1, 19)).length
    assert_equal 1, t.trainings.recent(1, DateTime.new(2008, 1, 19)).length
    assert_equal 3, t.trainings.recent(nil, DateTime.new(2008, 1, 21)).length
  end
  
  def test_trainings_calendar_in_a_day
    t = Team.find(1)
    Training.destroy_all
    assert_equal 0, Training.count
    td = Time.now.next_month.next_month.monday.tomorrow.tomorrow
    #创建训练，每个训练时长2小时
    create_training(td, 1) #当前时间，落入今天
    create_training(td.at_midnight.ago(7200).since(1), 1) #昨天晚上10点过1秒，结束时落入今天 
    create_training(td.at_midnight.tomorrow.ago(1), 1) #明天0点前1秒，落入今天  
    create_training(td.at_midnight.ago(7200), 1) #昨天晚上10点  
    create_training(td.at_midnight.tomorrow, 1) #明天0点    
    assert_equal 3, t.trainings.in_a_day(td).length
  end
  
  def test_trainings_calendar_in_a_week
    t = Team.find(1)
    Training.destroy_all
    assert_equal 0, Training.count
    td = Time.now.next_month.next_month.monday.tomorrow.tomorrow
    #创建训练，每个训练时长2小时
    create_training(td, 1) #当前时间，落入本周
    create_training(td.monday.ago(7200).since(1), 1) #上周日晚上10点过1秒，结束时落入本周
    create_training(td.monday.next_week.ago(1), 1) #下周一0点前1秒，落入本周
    create_training(td.monday.ago(7200), 1) #上周日晚上10点
    create_training(td.monday.next_week, 1) #下周一0点
    assert_equal 3, t.trainings.in_a_week(td).length
  end
  
  def test_trainings_calendar_in_a_month
    t = Team.find(1)
    Training.destroy_all
    assert_equal 0, Training.count
    td = Time.now.next_month.next_month.monday.tomorrow.tomorrow
    #创建训练，每个训练时长2小时
    create_training(td, 1) #当前时间，落入本月
    create_training(td.at_beginning_of_month.ago(7200).since(1), 1) #上月最后一天晚上10点过1秒，结束时落入本月
    create_training(td.at_beginning_of_month.next_month.ago(1), 1) #下月第一天0点前1秒，落入本月
    create_training(td.at_beginning_of_month.ago(7200), 1) #上月最后一天晚上10点
    create_training(td.at_beginning_of_month.next_month, 1) #下月第一天0点
    assert_equal 3, t.trainings.in_a_month(td).length
  end
  
  def test_trainings_in_later_24_hours
    t = Team.find(1)
    Training.destroy_all
    assert_equal 0, Training.count
    td = Time.now.next_month.next_month.monday.tomorrow.tomorrow
    #创建训练，每个训练时长2小时
    create_training(td, 1) #当前时间，落入未来24小时
    create_training(td.tomorrow.ago(1), 1) #当前时间24小时之后前1秒，落入未来24小时
    create_training(td.tomorrow, 1) #当前时间24小时之后
    assert_equal 2, t.trainings.in_later_hours(24, td).length
  end
  
  def test_users
    assert_equal 2,  teams(:inter).users.length
    assert_equal 2,  teams(:milan).users.length
    assert_equal 2,  teams(:inter).users.admin.length
    assert_equal 1,  teams(:milan).users.admin.length
    assert_equal 2,  teams(:inter).users.players.length
    assert_equal 0,  teams(:milan).users.players.length
  end
  
  def test_destroy
    ms = Match.count :conditions => ['host_team_id = ? or guest_team_id = ?', teams(:inter).id,  teams(:inter).id]
    sms = SidedMatch.find_all_by_host_team_id(teams(:inter)).size
    assert_not_equal 0, ms
    assert_not_equal 0, sms
    
    assert_difference 'TeamImage.count', -(TeamImage.find_all_by_team_id(teams(:inter)).size) do
    assert_difference 'Training.count', -(Training.find_all_by_team_id(teams(:inter)).size) do
    assert_difference 'Match.count', -ms do
    assert_difference 'SidedMatch.count', -sms do
    assert_difference 'UserTeam.count', -(UserTeam.find_all_by_team_id(teams(:inter)).size) do
    assert_difference 'TeamJoinRequest.count', -(TeamJoinRequest.find_all_by_team_id(teams(:inter)).size) do
    assert_difference 'Post.count', -(Post.find_all_by_team_id(teams(:inter)).size) do
      inter = teams(:inter)
      inter.destroy
    end
    end
    end
    end
    end
    end
    end
  end
  
  def test_search
    Team.create!({:name => 'Beijing Guo An', :shortname=>'BGA'})
    Team.create!({:name => 'Beijing Kuan Li', :shortname=>'BKL'})
    teams = Team.find_by_contents("BGA")
    assert 1, teams.length
    teams = Team.find_by_contents("Beijing")
    assert 2, teams.length
  end
  
  def test_recent_match #测试team.matches.recent
    t1 = Team.create!(:name=>"test1",:shortname=>"t1")
    t2 = Team.create!(:name=>"test2",:shortname=>"t2")
    
    m1 = Match.new
    m1.host_team_id = t1.id
    m1.guest_team_id = t2.id
    m1.start_time = 7.days.ago
    m1.location = 'Building 26'
    m1.save!
    m2 = Match.new
    m2.host_team_id = t2.id
    m2.guest_team_id = t1.id
    m2.start_time = 7.days.since
    m2.location = 'Building 45A'
    m2.save!
    
    assert_equal [m1,m2], t1.match_calendar_proxy.find(:all).sort_by{|i| i.start_time}
    assert_equal [m2], t1.match_calendar_proxy.recent        
  end  
  
  private
  def create_training(start_time, team_id)
    t = Training.new(:start_time => start_time, :end_time => start_time.since(7200), :location => 'Beijing')
    t.team_id = team_id
    t.save!
  end
end