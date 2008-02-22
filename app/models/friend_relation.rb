class FriendRelation < ActiveRecord::Base
  belongs_to :user1, :class_name=>"User", :foreign_key=>"user1_id"
  belongs_to :user2, :class_name=>"User", :foreign_key=>"user2_id"
  
  def self.are_friends?(user1_id, user2_id)
    (FriendRelation.count(:conditions => ["(user1_id = ? and user2_id = ?) or (user2_id = ? and user1_id = ?)", 
     user1_id, user2_id, user1_id, user2_id]) > 0)
  end
end
