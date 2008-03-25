require File.dirname(__FILE__) + '/../test_helper'

class MatchJoinTest < ActiveSupport::TestCase
  
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
