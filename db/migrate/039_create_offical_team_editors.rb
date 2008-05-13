class CreateOfficalTeamEditors < ActiveRecord::Migration
  def self.up
    create_table :offical_team_editors, :id => false do |t|
      t.integer :user_id
    end
    add_index :offical_team_editors, :user_id
  end

  def self.down
    drop_table :offical_team_editors
  end
end
