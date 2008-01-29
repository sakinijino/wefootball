class FriendRelation < ActiveRecord::Base
  def self.are_friends?(user1_id, user2_id)
    (FriendRelation.count(:conditions => ["(user1_id = ? and user2_id = ?) or (user2_id = ? and user1_id = ?)", 
     user1_id, user2_id, user1_id, user2_id]) > 0)
  end
end
