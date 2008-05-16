class PolymorphismPost < ActiveRecord::Migration
  def self.up
    add_column :posts, :activity_id, :integer
    add_column :posts, :type, :string
    
    Post.update_all(['type = ?, activity_id = training_id', 'TrainingPost'], 'training_id is not null')
    Post.update_all(['type = ?, activity_id = sided_match_id', 'SidedMatchPost'], 'sided_match_id is not null')
    Post.update_all(['type = ?, activity_id = match_id', 'MatchPost'], 'match_id is not null')
    Post.update_all(['type = ?', 'Post'], 'activity_id is null')
  end

  def self.down
    remove_column :posts, :activity_id
    remove_column :posts, :type
  end
end
