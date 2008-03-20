class CreateFootballGroundEditors < ActiveRecord::Migration
  def self.up
    create_table :football_ground_editors, :id => false do |t|
      t.integer :user_id
    end
    add_index :football_ground_editors, :user_id
  end

  def self.down
    drop_table :football_ground_editors
  end
end
