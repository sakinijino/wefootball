class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string :title, :limit => 100
      t.text :content
      t.integer :team_id
      t.integer :training_id
      t.integer :match_id
      t.boolean :is_private, :default => false
      t.integer :user_id
      t.integer :replies_count, :default=>0
      
      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
