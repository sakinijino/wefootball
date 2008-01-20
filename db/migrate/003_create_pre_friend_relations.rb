class CreatePreFriendRelations < ActiveRecord::Migration
  def self.up
    create_table :pre_friend_relations do |t|
      t.integer :applier_id
      t.integer :host_id
      t.text :message
      t.date :apply_date
    end
  end

  def self.down
    drop_table :pre_friend_relations
  end
end
