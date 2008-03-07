class CreateMatchJoins < ActiveRecord::Migration
  def self.up
    create_table :match_joins do |t|
      t.integer :match_id
      t.integer :user_id
      t.boolean :play_for_host_team
      t.integer :goal
      t.integer :yellow_cards
      t.integer :red_cards
      t.integer :position
      t.integer :status
    end
  end

  def self.down
    drop_table :match_joins
  end
end
