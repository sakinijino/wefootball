class CreateTeamImages < ActiveRecord::Migration
  def self.up
    create_table :team_images do |t|
       t.string :filename
      t.string :content_type
      t.integer :size
      t.integer :parent_id
      t.string :thumbnail
      t.integer :team_id
    end
  end

  def self.down
    drop_table :team_images
  end
end
