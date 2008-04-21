class CreateUserTeams < ActiveRecord::Migration
  def self.up
    create_table :user_teams do |t|
      t.integer :user_id
      t.integer :team_id
      t.boolean :is_admin, :default=>false
      t.boolean :is_player, :default=>false
      t.integer :position, :limit=>2
    end
  end

  def self.down
    drop_table :user_teams
  end
end
