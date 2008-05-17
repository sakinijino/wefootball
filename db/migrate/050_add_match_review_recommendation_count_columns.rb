class AddMatchReviewRecommendationCountColumns < ActiveRecord::Migration
  def self.up
    add_column :match_reviews, :like_count, :integer, :default=>0
    add_column :match_reviews, :dislike_count, :integer, :default=>0  
  end

  def self.down
    remove_column :match_reviews, :like_count
    remove_column :match_reviews, :dislike_count
  end
end
