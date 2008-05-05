require File.dirname(__FILE__) + '/../test_helper'

class MatchJoinTest < ActiveSupport::TestCase
  
  def test_before_validation
    ut = UserTeam.find_by_user_id_and_team_id(users(:saki).id, teams(:milan).id)
    ut.is_player = true;
    ut.save!
    
    m = matches(:one)
    MatchJoin.create_joins(m)
    
    mjs = m.match_joins.guest_team
    mj = mjs.find{|i| i.user_id == users(:saki).id}
    mj.position = ""
    mj.save!
    assert_nil mj.position
    
    mj.position = 10
    mj.save!
    assert_equal 10, mj.position
    
    mj.position = 30
    mj.save
    assert_not_nil mj.errors.on(:position)
    
    mj = mjs.find{|i| i.user_id == users(:aaron).id}
    mj.position = 10
    mj.save!
    assert_nil mj.position
    
    mj.goal = 1;
    mj.position = 11
    mj.save!
    assert_equal 11, mj.position
    
    mj.goal = 0
    mj.yellow_card = 1
    mj.position = 12
    mj.save!
    assert_equal 12, mj.position
    
    mj.yellow_card = 0
    mj.red_card = 1
    mj.position = 13
    mj.save!
    assert_equal 13, mj.position
    
    mj.goal = ""
    mj.yellow_card = ""
    mj.red_card = ""
    mj.position = 14
    mj.save!
    assert_nil mj.position
  end
  
  def test_create_joins #测试create_joins是正确的
    m = matches(:one)
    MatchJoin.create_joins(m)
    users_from_match = m.match_joins.map{|mj| mj.user}.sort_by{|u| u.id}
    users_from_team = (m.host_team.users + m.guest_team.users).sort_by{|u| u.id}
    assert_equal users_from_match,users_from_team
  end
  
  def test_players #测试players是正确的
    m = matches(:one)
    MatchJoin.create_joins(m)    
    host_team_players_from_match_joins = MatchJoin.players(m.id,m.host_team_id).map{|mj| mj.user}.sort_by{|u| u.id}
    guest_team_players_from_match_joins = MatchJoin.players(m.id,m.guest_team_id).map{|mj| mj.user}.sort_by{|u| u.id}     
    host_team_players_from_team = m.host_team.users.players.sort_by{|u| u.id}
    guest_team_players_from_team = m.guest_team.users.players.sort_by{|u| u.id}   
    assert_equal host_team_players_from_match_joins,host_team_players_from_team
    assert_equal guest_team_players_from_match_joins,guest_team_players_from_team
    
    mj = MatchJoin.find(:first, :conditions => ["user_id = ? and match_id = ? and team_id = ?", users(:saki), m, teams(:inter)])
    mj.position = 12;
    mj.save!
    users(:saki).is_playable = false;
    users(:saki).save!
    assert MatchJoin.players(m.id,m.host_team_id).include?(mj)
    
    mj = MatchJoin.find(:first, :conditions => ["user_id = ? and match_id = ? and team_id = ?", users(:aaron), m, teams(:milan)])
    assert !MatchJoin.players(m.id,m.guest_team_id).include?(mj)
    mj.goal = 1;
    mj.save!
    assert MatchJoin.players(m.id,m.guest_team_id).include?(mj)
    mj.goal = 0;
    mj.yellow_card = 1;
    mj.save!
    assert MatchJoin.players(m.id,m.guest_team_id).include?(mj)
    mj.yellow_card = 0;
    mj.red_card = 1;
    mj.save!
    assert MatchJoin.players(m.id,m.guest_team_id).include?(mj)
  end
  
  def test_cards #测试红黄牌的赋值和读取是正确的
    mj = MatchJoin.new
    
    mj.cards = 0
    mj.save
    assert_equal 0, mj.red_card
    assert_equal 0, mj.yellow_card
    assert_equal 0, mj.cards
    
    mj.cards = 1
    mj.save    
    assert_equal 0, mj.red_card
    assert_equal 1, mj.yellow_card
    assert_equal 1, mj.cards    
    
    mj.cards = 2
    mj.save
    assert_equal 1, mj.red_card
    assert_equal 1, mj.yellow_card
    assert_equal 2, mj.cards      
    
    mj.cards = 3
    mj.save
    assert_equal 1, mj.red_card
    assert_equal 2, mj.yellow_card
    assert_equal 3, mj.cards      
    
    mj.cards = 4
    mj.save
    assert_equal 0, mj.red_card
    assert_equal 0, mj.yellow_card
    assert_equal 0, mj.cards      
  end
end
