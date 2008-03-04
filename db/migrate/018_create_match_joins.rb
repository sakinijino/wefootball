class CreateMatchJoins < ActiveRecord::Migration
  def self.up
    create_table :match_joins do |t|
      t.integer :match_id
      t.integer :user_id
      t.integer :goal
      t.integer :yellow_cards
      t.integer :red_cards
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :match_joins
  end
end
