require File.dirname(__FILE__) + '/../test_helper'

class FriendRelationTest < ActiveSupport::TestCase  
  def test_are_friends
    assert FriendRelation.are_friends?(users(:saki).id, users(:mike2).id)
    assert FriendRelation.are_friends?(users(:mike2).id, users(:saki).id)
  end
end
