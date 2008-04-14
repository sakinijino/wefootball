class AddSidedMatchPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :sided_match_id, :integer
  end

  def self.down
    remove_column :posts, :sided_match_id
  end
end
