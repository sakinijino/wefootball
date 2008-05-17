class CreateOfficialTeamImages < ActiveRecord::Migration
  def self.up
    create_table :official_team_images do |t|
      t.string :filename
      t.string :content_type
      t.integer :size
      t.integer :parent_id
      t.string :thumbnail
      t.integer :official_team_id
    end
  end

  def self.down
    drop_table :official_team_images
  end
end
