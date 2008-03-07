class CreateFootballGrounds < ActiveRecord::Migration
  def self.up
    create_table :football_grounds do |t|
      t.string :name, :limit => 50
      t.integer :city, :default=>0
      t.integer :ground_type, :limit => 2, :default=>1
      t.integer :status, :limit => 1, :default=>0
      t.text :description
      t.decimal :longitude
      t.decimal :latitude
      t.integer :user_id
    end
  end

  def self.down
    drop_table :football_grounds
  end
end
