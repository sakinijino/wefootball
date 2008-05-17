class CreateMatchReviewReplies < ActiveRecord::Migration
  def self.up
    create_table :match_review_replies do |t|
      t.text :content
      t.integer :match_review_id
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :match_review_replies
  end
end
