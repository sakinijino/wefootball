class CreateOfficalTeams < ActiveRecord::Migration
  def self.up
    create_table :offical_teams do |t|
      t.string :name, :limit => 15
      t.string :image_path
      t.text :description
      t.integer :user_id
    end
  end

  def self.down
    drop_table :offical_teams
  end
end
