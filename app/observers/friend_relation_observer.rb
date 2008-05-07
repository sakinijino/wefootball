class FriendRelationObserver < ActiveRecord::Observer
  def after_create(friend_relation)
    FriendCreationBroadcast.create!(:user_id=>friend_relation.user1_id,
                                   :friend_id=>friend_relation.user2_id)
    FriendCreationBroadcast.create!(:user_id=>friend_relation.user2_id,
                                   :friend_id=>friend_relation.user1_id)
  
  end 
end
