class AddFootballGroundProperties < ActiveRecord::Migration
  def self.up
    add_column :match_invitations, :new_football_ground_id, :integer
    add_column :match_invitations, :football_ground_id, :integer    
    add_column :matches, :football_ground_id, :integer
    add_column :sided_matches, :football_ground_id, :integer    
  end

  def self.down
    remove_column :match_invitations, :new_football_ground_id    
    remove_column :match_invitations, :football_ground_id
    remove_column :matches, :football_ground_id
    remove_column :sided_matches, :football_ground_id 
  end
end
