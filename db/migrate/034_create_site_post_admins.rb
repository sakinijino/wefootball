class CreateSitePostAdmins < ActiveRecord::Migration
  def self.up
    create_table :site_post_admins, :id => false do |t|
      t.integer :user_id
    end
    add_index :site_post_admins, :user_id
  end

  def self.down
    drop_table :site_post_admins
  end
end
