class CreateMatchReviews < ActiveRecord::Migration
  def self.up
    create_table :match_reviews do |t|
      t.string :title, :limit => 100
      t.text :content
      t.integer :match_id
      t.string :type
      t.integer :user_id
      t.integer :score, :default=>0
      t.integer :match_review_replies_count, :default=>0
      t.timestamps
    end
  end

  def self.down
    drop_table :match_reviews
  end
end
