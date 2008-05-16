class PolymorphismPostCleaner < ActiveRecord::Migration
  def self.up
    remove_column :posts, :match_id
    remove_column :posts, :sided_match_id
    remove_column :posts, :training_id
  end

  def self.down
    add_column :posts, :match_id, :integer
    add_column :posts, :sided_match_id, :integer
    add_column :posts, :training_id, :integer
    
    MatchPost.update_all(['match_id = activity_id'])
    SidedMatchPost.update_all(['sided_match_id = activity_id'])
    TrainingPost.update_all(['training_id = activity_id'])
  end
end
