require File.dirname(__FILE__) + '/../test_helper'

class FootballGroundTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_before_validation
    fg = FootballGround.create!({:name => 'nickname'*50, 
        :description => 'summary'*1000 })
    assert fg.valid?, "#{fg.errors.full_messages.to_sentence}"
    assert_equal 50, fg.name.length
    assert_equal 5000, fg.description.length
  end
  
  def test_before_destroy
    t = Training.create!(:football_ground_id => football_grounds(:yiti))
    assert_equal football_grounds(:yiti).name, t.location
    football_grounds(:yiti).name = "Modify"
    football_grounds(:yiti).save!
    football_grounds(:yiti).destroy
    t.reload
    assert_nil t.football_ground_id
    assert_equal "Modify", t.location
  end
  
  def test_merge
    t1 = Training.create!(:football_ground_id => football_grounds(:yiti))
    t2 = Training.create!(:football_ground_id => football_grounds(:yiti))
    assert_difference("FootballGround.count", -1) do
    assert_difference("Training.count :conditions => ['football_ground_id = ?', football_grounds(:yiti).id]", -2) do
    assert_difference("Training.count :conditions => ['football_ground_id = ?', football_grounds(:wusi).id]", 2) do
      football_grounds(:yiti).merge_to_and_delete(football_grounds(:wusi))
    end
    end
    end
    t1.reload
    t2.reload
    assert_equal football_grounds(:wusi).id, t1.football_ground_id
    assert_equal football_grounds(:wusi).id, t2.football_ground_id
    assert_equal football_grounds(:wusi).name, t1.location
    assert_equal football_grounds(:wusi).name, t2.location
  end
end
