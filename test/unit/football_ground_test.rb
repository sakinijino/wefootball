require File.dirname(__FILE__) + '/../test_helper'

class FootballGroundTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_before_validation
    fg = FootballGround.create!({:name => 'n'*50, 
        :description => 'summary'*1000 })
    assert fg.valid?, "#{fg.errors.full_messages.to_sentence}"
    assert_equal 3000, fg.description.length
  end
  
  def test_before_destroy
    t = Training.new(:football_ground_id => football_grounds(:yiti))
    t.team_id = teams(:inter)
    t.save!
    p = Play.new(:football_ground_id => football_grounds(:yiti))
    p.save!
    m = Match.new()
    m.football_ground_id = football_grounds(:yiti)
    m.save!
    sm = SidedMatch.new(:football_ground_id => football_grounds(:yiti), :guest_team_name => 'AC')
    sm.save!
    assert_equal football_grounds(:yiti).name, t.location
    assert_equal football_grounds(:yiti).name, p.location
    assert_equal football_grounds(:yiti).name, m.location
    assert_equal football_grounds(:yiti).name, sm.location
    football_grounds(:yiti).name = "Modify"
    football_grounds(:yiti).save!
    football_grounds(:yiti).destroy
    t.reload
    p.reload
    m.reload
    sm.reload
    assert_nil t.football_ground_id
    assert_nil p.football_ground_id
    assert_nil m.football_ground_id
    assert_nil sm.football_ground_id
    assert_equal "Modify", t.location
    assert_equal "Modify", p.location
    assert_equal "Modify", m.location
    assert_equal "Modify", sm.location
  end
  
  def test_merge
    Training.destroy_all
    Play.destroy_all
    Match.destroy_all
    SidedMatch.destroy_all
    
    t1 = Training.new(:football_ground_id => football_grounds(:yiti))
    t1.team_id = teams(:inter)
    t1.save!
    t2 = Training.new(:football_ground_id => football_grounds(:yiti))
    t2.team_id = teams(:inter)
    t2.save!
    p1 = Play.new(:football_ground_id => football_grounds(:yiti))
    p1.save!
    p2 = Play.new(:football_ground_id => football_grounds(:yiti))
    p2.save!
    m1 = Match.new()
    m1.football_ground_id = football_grounds(:yiti)
    m1.save!
    m2 = Match.new()
    m2.football_ground_id = football_grounds(:yiti)
    m2.save!
    sm1 = SidedMatch.new(:football_ground_id => football_grounds(:yiti), :guest_team_name => 'AC')
    sm1.save!
    sm2 = SidedMatch.new(:football_ground_id => football_grounds(:yiti), :guest_team_name => 'AC')
    sm2.save!
    
    assert_difference("FootballGround.count", -1) do
    assert_difference("SidedMatch.count :conditions => ['football_ground_id = ?', football_grounds(:yiti).id]", -2) do
    assert_difference("SidedMatch.count :conditions => ['football_ground_id = ?', football_grounds(:wusi).id]", 2) do
    assert_difference("Match.count :conditions => ['football_ground_id = ?', football_grounds(:yiti).id]", -2) do
    assert_difference("Match.count :conditions => ['football_ground_id = ?', football_grounds(:wusi).id]", 2) do
    assert_difference("Training.count :conditions => ['football_ground_id = ?', football_grounds(:yiti).id]", -2) do
    assert_difference("Training.count :conditions => ['football_ground_id = ?', football_grounds(:wusi).id]", 2) do
    assert_difference("Play.count :conditions => ['football_ground_id = ?', football_grounds(:yiti).id]", -2) do
    assert_difference("Play.count :conditions => ['football_ground_id = ?', football_grounds(:wusi).id]", 2) do
      football_grounds(:yiti).merge_to_and_delete(football_grounds(:wusi))
    end
    end
    end
    end
    end
    end
    end
    end
    end
    t1.reload
    t2.reload
    p1.reload
    p2.reload
    m1.reload
    m2.reload
    sm1.reload
    sm2.reload
    assert_equal football_grounds(:wusi).id, t1.football_ground_id
    assert_equal football_grounds(:wusi).id, t2.football_ground_id
    assert_equal football_grounds(:wusi).name, t1.location
    assert_equal football_grounds(:wusi).name, t2.location
    
    assert_equal football_grounds(:wusi).id, p1.football_ground_id
    assert_equal football_grounds(:wusi).id, p2.football_ground_id
    assert_equal football_grounds(:wusi).name, p1.location
    assert_equal football_grounds(:wusi).name, p2.location
    
    assert_equal football_grounds(:wusi).id, m1.football_ground_id
    assert_equal football_grounds(:wusi).id, m2.football_ground_id
    assert_equal football_grounds(:wusi).name, m1.location
    assert_equal football_grounds(:wusi).name, m2.location
    
    assert_equal football_grounds(:wusi).id, sm1.football_ground_id
    assert_equal football_grounds(:wusi).id, sm2.football_ground_id
    assert_equal football_grounds(:wusi).name, sm1.location
    assert_equal football_grounds(:wusi).name, sm2.location
  end
end
