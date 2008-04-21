class CreatePlayJoins < ActiveRecord::Migration
  def self.up
    create_table :play_joins do |t|
      t.integer :user_id
      t.integer :play_id
    end
  end

  def self.down
    drop_table :play_joins
  end
end
