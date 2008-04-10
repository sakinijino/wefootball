class CreateMatches < ActiveRecord::Migration
  def self.up
    create_table :matches do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.string :location, :limit=>100, :default=>''
      t.integer :match_type
      t.integer :size,:default=>5
      t.boolean :has_judge
      t.boolean :has_card
      t.boolean :has_offside
      t.integer :win_rule
      t.text :description
      t.integer :half_match_length, :default=>0
      t.integer :rest_length, :default=>0
      t.integer :host_team_id
      t.integer :guest_team_id
      t.integer :host_team_goal_by_host
      t.integer :guest_team_goal_by_host
      t.integer :host_team_goal_by_guest
      t.integer :guest_team_goal_by_guest
      t.integer :situation_by_host
      t.integer :situation_by_guest
      t.boolean :has_conflict
      t.timestamps
    end
  end

  def self.down
    drop_table :matches
  end
end
