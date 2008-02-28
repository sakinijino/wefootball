class CreateTeams < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.string :name, :limit => 200
      t.string :shortname, :limit => 20
      t.text :summary
      t.date :found_time
      t.string :style, :limit=>20, :default=>''
    end
  end

  def self.down
    drop_table :teams
  end
end