class CreateOfficalMatches < ActiveRecord::Migration
  def self.up
    create_table :offical_matches do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.string :location, :limit=>100, :default=>''
      t.text :description
      t.integer :host_offical_team_id
      t.integer :guest_offical_team_id
      t.integer :host_team_goal
      t.integer :guest_team_goal
      t.integer :host_team_pk_goal
      t.integer :guest_team_pk_goal
      t.integer :user_id
    end
  end

  def self.down
    drop_table :offical_matches
  end
end
