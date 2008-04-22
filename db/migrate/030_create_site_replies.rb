class CreateSiteReplies < ActiveRecord::Migration
  def self.up
    create_table :site_replies do |t|
      t.text :content
      t.integer :site_post_id
      t.integer :user_id
      t.string :email

      t.timestamps
    end
  end

  def self.down
    drop_table :site_replies
  end
end
