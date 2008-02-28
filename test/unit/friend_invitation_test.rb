require File.dirname(__FILE__) + '/../test_helper'

class FriendInvitationTest < ActiveSupport::TestCase
  fixtures :friend_invitations
  
  def test_attr_protected
    fi = friend_invitations(:quentin_to_aaron)
    fi.update_attributes({:applier_id=>3, :host_id=>4})
    assert_equal 1, fi.applier_id
    assert_equal 2, fi.host_id
  end
  
  def test_message_length
    fi = friend_invitations(:quentin_to_aaron)
    fi.update_attributes({:message=>'s'*1000})
    assert_equal 500, fi.message.length
  end
  
  def test_apply_date
    fi = FriendInvitation.new()
    fi.save
    assert_equal Date.today, fi.apply_date
  end
end
