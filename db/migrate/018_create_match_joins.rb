class CreateMatchJoins < ActiveRecord::Migration
  def self.up
    create_table :match_joins do |t|
      t.integer :match_id
      t.integer :user_id
      t.integer :team_id
      t.integer :goal, :default=>0
      t.integer :yellow_card, :default=>0
      t.integer :red_card, :default=>0
      t.integer :position
      t.integer :status
      t.text :comment, :default=>''

      t.timestamps
    end
  end

  def self.down
    drop_table :match_joins
  end
end
