require File.dirname(__FILE__) + '/../test_helper'

class MessageTest < ActiveSupport::TestCase
  def test_can_read_by
    m1 = messages(:saki_mike1)
    assert m1.can_read_by?(users(:saki))
    assert m1.can_read_by?(users(:mike1).id)
    m1 = messages(:saki_mike1_2)
    assert !m1.can_read_by?(users(:saki))
    m1 = messages(:saki_mike1_3)
    assert !m1.can_read_by?(users(:mike1).id)
  end
  
  def test_sender_destroy_message
    assert_no_difference('Message.count') do
      messages(:mike2_saki).destroy_by!(users(:mike2))
      assert messages(:mike2_saki).is_delete_by_sender
    end
  end
  
  def test_receiver_destroy_message
    assert_no_difference('Message.count') do
      messages(:mike2_saki).destroy_by!(users(:saki))
      assert messages(:mike2_saki).is_delete_by_receiver
    end
  end
  
  def test_both_destroy_message
    assert_difference('Message.count', -1) do
      messages(:mike2_saki_2).destroy_by!(users(:mike2))
    end
  end
end
