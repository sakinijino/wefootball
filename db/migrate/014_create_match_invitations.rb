class CreateMatchInvitations < ActiveRecord::Migration
  def self.up
    create_table :match_invitations do |t|
      t.datetime :start_time
      t.string :location, :limit=>100
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
      t.boolean :edit_by_host_team
      t.datetime :new_start_time
      t.string :new_location, :limit=>100
      t.integer :new_match_type
      t.integer :new_size
      t.boolean :new_has_judge
      t.boolean :new_has_card
      t.boolean :new_has_offside
      t.integer :new_win_rule
      t.text :new_description
      t.integer :new_half_match_length
      t.integer :new_rest_length
      t.text :host_team_message
      t.text :guest_team_message    
      t.timestamps
    end
  end

  def self.down
    drop_table :match_invitations
  end
end
