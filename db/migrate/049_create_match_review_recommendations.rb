class CreateMatchReviewRecommendations < ActiveRecord::Migration
  def self.up
    create_table :match_review_recommendations do |t|
      t.integer :user_id
      t.integer :match_review_id
      t.integer :status

      t.timestamps
    end
  end

  def self.down
    drop_table :match_review_recommendations
  end
end
