class CreateWatches < ActiveRecord::Migration
  def self.up
    create_table :watches do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.string :location, :limit=>100, :default=>''
      t.integer :official_match_id
      t.integer :user_id
      t.text :description
    end
  end

  def self.down
    drop_table :watches
  end
end
