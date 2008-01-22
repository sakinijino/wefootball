class CreateTrainings < ActiveRecord::Migration
  def self.up
    create_table :trainings do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.string :location, :limit=>300, :default=>''
      t.text :summary
      t.integer :team_id
    end
  end

  def self.down
    drop_table :trainings
  end
end
