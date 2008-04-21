class CreateSidedMatches < ActiveRecord::Migration
  def self.up
    create_table :sided_matches do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.string :location, :limit=>300, :default=>''
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
      t.string :guest_team_name, :limit=>15
      t.integer :host_team_goal
      t.integer :guest_team_goal
      t.integer :situation
      t.timestamps
    end
  end

  def self.down
    drop_table :sided_matches
  end
end
