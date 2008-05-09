require File.dirname(__FILE__) + '/../test_helper'

class FriendInvitationTest < ActiveSupport::TestCase
  fixtures :friend_invitations
  
  def test_attr_protected
    fi = friend_invitations(:quentin_to_aaron)
    fi.update_attributes!({:applier_id=>3, :host_id=>4})
    assert_equal 1, fi.applier_id
    assert_equal 2, fi.host_id
  end
  
  def test_message_length
    fi = friend_invitations(:quentin_to_aaron)
    fi.update_attributes!({:message=>'s'*1000})
    assert_equal 150, fi.message.length
  end
  
  def test_apply_date
    fi = FriendInvitation.new()
    fi.host_id = users(:saki).id
    fi.applier_id = users(:quentin).id
    fi.save!
    assert_equal Date.today, fi.apply_date
  end
  
  def test_friend_invitations_count
    fi = FriendInvitation.new()
    assert_difference "users(:saki).reload.friend_invitations_count", 1 do
    assert_no_difference "users(:quentin).reload.friend_invitations_count" do
      fi.host_id = users(:saki).id
      fi.applier_id = users(:quentin).id
      fi.save!
    end
    end
    
    assert_difference "users(:saki).reload.friend_invitations_count", -1 do
    assert_no_difference "users(:quentin).reload.friend_invitations_count" do
      fi.destroy
    end
    end
  end
end
