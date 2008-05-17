class CreateWatchJoins < ActiveRecord::Migration
  def self.up
    create_table :watch_joins do |t|
      t.integer :user_id
      t.integer :watch_id

      t.timestamps
    end
  end

  def self.down
    drop_table :watch_joins
  end
end
