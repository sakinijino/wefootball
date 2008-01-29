class CreateTeamJoinRequests < ActiveRecord::Migration
  def self.up
    create_table :team_join_requests do |t|
      t.integer :user_id
      t.integer :team_id
      t.boolean :is_invitation, :default=>false
      t.string :message, :limit=>500, :default=>''
      t.date :apply_date
    end
  end

  def self.down
    drop_table :team_join_requests
  end
end
