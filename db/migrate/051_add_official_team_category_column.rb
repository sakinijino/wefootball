class AddOfficialTeamCategoryColumn < ActiveRecord::Migration
  def self.up
    add_column :official_teams, :category, :integer
    OfficialTeam.update_all(['category = ?', 7])
  end

  def self.down
    remove_column :official_teams, :category
  end
end
