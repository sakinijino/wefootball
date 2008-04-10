class CreatePlays < ActiveRecord::Migration
  def self.up
    create_table :plays do |t|
      t.datetime :start_time
      t.datetime :end_time      
      t.string :location, :limit=>100, :default=>''
      t.integer :football_ground_id
    end
  end

  def self.down
    drop_table :plays
  end
end
