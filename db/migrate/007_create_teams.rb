class CreateTeams < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.string :name, :limit => 50
      t.string :shortname, :limit => 15
      t.integer :city, :limit=>3, :default=>0
      t.text :summary
      t.date :found_time
      t.string :image_path
      t.string :style, :limit=>50, :default=>''
    end
  end

  def self.down
    drop_table :teams
  end
end