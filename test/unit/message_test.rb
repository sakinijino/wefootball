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
  
  def test_unread_messages_count
    u1 = users(:saki)
    u2 = users(:quentin)
    
    u1.unread_messages_count = 10;
    u2.unread_messages_count = 10;
    u1.save!
    u2.save!
    
    m1 = Message.new
    m2 = Message.new
    m3 = Message.new
    
    assert_difference('u1.reload.unread_messages_count', 3) do
    assert_no_difference('u2.reload.unread_messages_count') do
      m1.receiver = u1
      m1.sender = u2
      m1.subject = '123'
      m1.content = '123'
      m1.save!
      m2.receiver = u1
      m2.sender = u2
      m2.subject = '123'
      m2.content = '123'
      m2.save!
      m3.receiver = u1
      m3.sender = u2
      m3.subject = '123'
      m3.content = '123'
      m3.save!
    end
    end
    
    assert_difference('u1.reload.unread_messages_count', -1) do
    assert_no_difference('u2.reload.unread_messages_count') do
      m1.receiver_read!
    end
    end
    
    assert_no_difference('u1.reload.unread_messages_count') do
    assert_no_difference('u2.reload.unread_messages_count') do
      m2.destroy_by!(u2)
    end
    end
    
    assert_difference('u1.reload.unread_messages_count', -1) do
    assert_no_difference('u2.reload.unread_messages_count') do
      m2.destroy_by!(u1)
    end
    end
    
    assert_difference('u1.reload.unread_messages_count', -1) do
    assert_no_difference('u2.reload.unread_messages_count') do
      m3.destroy_by!(u1)
    end
    end
    
    assert_no_difference('u1.reload.unread_messages_count') do
    assert_no_difference('u2.reload.unread_messages_count') do
      m3.destroy_by!(u2)
    end
    end
  end
  
end
