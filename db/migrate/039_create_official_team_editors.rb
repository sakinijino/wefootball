class CreateOfficialTeamEditors < ActiveRecord::Migration
  def self.up
    create_table :official_team_editors, :id => false do |t|
      t.integer :user_id
    end
    add_index :official_team_editors, :user_id
  end

  def self.down
    drop_table :official_team_editors
  end
end
