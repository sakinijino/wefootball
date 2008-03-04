class CreateMatches < ActiveRecord::Migration
  def self.up
    create_table :matches do |t|
      t.datetime :start_time
      t.string :location
      t.integer :match_type
      t.integer :size
      t.boolean :has_judge
      t.boolean :has_card
      t.boolean :has_offside
      t.integer :win_rule
      t.text :description
      t.integer :half_match_length
      t.integer :rest_length
      t.integer :host_team_id
      t.integer :guest_team_id
      t.integer :host_team_goal
      t.integer :guest_team_goal
      t.integer :situation

      t.timestamps
    end
  end

  def self.down
    drop_table :matches
  end
end
