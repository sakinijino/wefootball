class CreateFriendRelations < ActiveRecord::Migration
  def self.up
    create_table :friend_relations do |t|
      t.integer :user1_id
      t.integer :user2_id

      t.timestamps
    end
  end

  def self.down
    drop_table :friend_relations
  end
end
