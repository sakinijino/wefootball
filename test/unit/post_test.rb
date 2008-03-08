require File.dirname(__FILE__) + '/../test_helper'

class PostTest < ActiveSupport::TestCase
  # Replace this with your real tests.  
  def test_visible
    assert posts(:saki_1).is_visible_to?(users(:aaron))
    assert posts(:saki_1).is_visible_to?(users(:quentin))
    assert posts(:quentin_2).is_visible_to?(users(:quentin))
    assert posts(:quentin_2).is_visible_to?(users(:saki))
    assert posts(:quentin_2).is_visible_to?(users(:aaron))
    assert !posts(:quentin_2).is_visible_to?(users(:mike1))
  end
  
  def test_can_reply
    assert posts(:saki_1).can_be_replied_by?(users(:saki))
    assert posts(:saki_1).can_be_replied_by?(users(:quentin))
    assert !posts(:saki_1).can_be_replied_by?(users(:aaron))
  end
  
  def test_modify
    assert posts(:saki_1).can_be_modified_by?(users(:saki))
    assert !posts(:saki_1).can_be_modified_by?(users(:quentin))
  end
  
  def test_can_destroy
    assert posts(:saki_1).can_be_destroyed_by?(users(:saki))
    assert posts(:saki_1).can_be_destroyed_by?(users(:quentin))
    assert !posts(:saki_1).can_be_destroyed_by?(users(:mike1))
    assert posts(:quentin_2).can_be_destroyed_by?(users(:quentin))
    assert posts(:quentin_2).can_be_destroyed_by?(users(:saki))
    assert !posts(:quentin_2).can_be_destroyed_by?(users(:aaron))
  end
  
  def test_destroy
    assert_difference 'Reply.count', -1 do
      posts(:saki_1).destroy
    end
  end
end
