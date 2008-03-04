class CreateUserPositions < ActiveRecord::Migration
  def self.up
    create_table :positions do |t|
      t.integer :user_id
      t.integer :label, :limit=>2
    end
  end

  def self.down
    drop_table :positions
  end
end
