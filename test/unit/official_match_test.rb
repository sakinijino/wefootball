require File.dirname(__FILE__) + '/../test_helper'

class OfficialMatchTest < ActiveSupport::TestCase
  def test_end_time
    m = OfficialMatch.new
    st = Time.today.tomorrow
    et = st.since(60*105)
    m.start_time = st
    m.host_team = official_teams(:inter)
    m.host_team = official_teams(:milan)
    m.save!
    assert_equal et, m.end_time
  end
  
  def test_before_validation
    m = OfficialMatch.new
    st = Time.today.tomorrow
    m.start_time = st
    m.host_team = official_teams(:inter)
    m.host_team = official_teams(:milan)
    m.description = "description"*1000
    assert m.valid?
    assert_equal 3000, m.description.length
  end
  
  def test_time_check
    m = OfficialMatch.new
    m.start_time = Time.now.tomorrow
    m.host_team = official_teams(:inter)
    m.host_team = official_teams(:milan)
    m.save!
    assert !m.started?
    assert !m.finished?
    
    m = OfficialMatch.new
    m.start_time = Time.now.ago(1800)
    m.host_team = official_teams(:inter)
    m.host_team = official_teams(:milan)
    m.save!
    assert m.started?
    assert !m.finished?
    
    m = OfficialMatch.new
    m.start_time = 1.days.ago
    m.host_team = official_teams(:inter)
    m.host_team = official_teams(:milan)
    m.save!
    assert m.started?
    assert m.finished?
  end
  
  def test_pk
    m = OfficialMatch.new
    m.host_team_goal = 2
    m.guest_team_goal = 1
    assert !m.pk?
    m.host_team_pk_goal = 0
    m.guest_team_pk_goal = 0
    assert !m.pk?
    m.host_team_pk_goal = 6
    m.guest_team_pk_goal = 5
    assert m.pk?
    m.host_team_pk_goal = 3
    m.guest_team_pk_goal = 0
    assert m.pk?
    m.host_team_pk_goal = 0
    m.guest_team_pk_goal = 3
    assert m.pk?
    m.host_team_pk_goal = nil
    m.guest_team_pk_goal = nil
    assert !m.pk?
  end
  
  def test_user_destroy_dependency_nullify
    u = users(:saki)
    l  = u.official_matches.size
    assert_no_difference "OfficialMatch.count" do
    assert_difference "OfficialMatch.find(:all, :conditions=>['user_id is null']).length", l do
      u.destroy
    end
    end
  end
end
