require File.dirname(__FILE__) + '/../test_helper'

class SidedMatchJoinTest < ActiveSupport::TestCase
  
  def test_before_validation
    ut = UserTeam.find_by_user_id_and_team_id(users(:saki).id, teams(:milan).id)
    ut.is_player = true;
    ut.save!
    
    m = sided_matches(:one)
    m.host_team = teams(:milan)
    m.save!
    SidedMatchJoin.create_joins(m)
    
    mjs = m.sided_match_joins
    mj = mjs.to_a.find{|i| i.user_id == users(:saki).id}
    mj.position = ""
    mj.save!
    assert_nil mj.position
    
    mj.position = 10
    mj.save!
    assert_equal 10, mj.position
    
    mj.position = 30
    mj.save
    assert_not_nil mj.errors.on(:position)
    
    mj = mjs.to_a.find{|i| i.user_id == users(:aaron).id}
    mj.position = 10
    mj.save!
    assert_nil mj.position
  end
  
  def test_create_joins #测试create_joins是正确的
    m = sided_matches(:one)
    SidedMatchJoin.create_joins(m)
    users_from_match = m.sided_match_joins.map{|mj| mj.user}.sort_by{|u| u.id}
    users_from_team = (m.host_team.users).sort_by{|u| u.id}
    assert_equal users_from_match,users_from_team
  end
  
  def test_players #测试players是正确的
    m = sided_matches(:one)
    SidedMatchJoin.create_joins(m)    
    host_team_players_from_match_joins = SidedMatchJoin.players(m).map{|mj| mj.user}.sort_by{|u| u.id} 
    host_team_players_from_team = m.host_team.users.players.sort_by{|u| u.id} 
    assert_equal host_team_players_from_match_joins,host_team_players_from_team    
  end
  
  def test_cards #测试红黄牌的赋值和读取是正确的
    mj = SidedMatchJoin.new
    
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
