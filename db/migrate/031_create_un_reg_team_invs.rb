class CreateUnRegTeamInvs < ActiveRecord::Migration
  def self.up
    create_table :un_reg_team_invs do |t|
      t.integer :user_id
      t.integer :invitation_id
      t.integer :team_id
    end
  end

  def self.down
    drop_table :un_reg_team_invs
  end
end
