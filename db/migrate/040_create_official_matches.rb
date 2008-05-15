class CreateOfficialMatches < ActiveRecord::Migration
  def self.up
    create_table :official_matches do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.string :location, :limit=>100, :default=>''
      t.text :description
      t.integer :host_official_team_id
      t.integer :guest_official_team_id
      t.integer :host_team_goal
      t.integer :guest_team_goal
      t.integer :host_team_pk_goal
      t.integer :guest_team_pk_goal
      t.integer :user_id
    end
  end

  def self.down
    drop_table :official_matches
  end
end
