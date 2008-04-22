class CreateSitePosts < ActiveRecord::Migration
  def self.up
    create_table :site_posts do |t|
      t.string :title, :limit => 100
      t.text :content
      t.integer :user_id
      t.string :email
      t.integer :site_replies_count, :default=>0

      t.timestamps
    end
  end

  def self.down
    drop_table :site_posts
  end
end
