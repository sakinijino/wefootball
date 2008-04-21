class CreateUserImages < ActiveRecord::Migration
  def self.up
    create_table :user_images do |t|
      t.string :filename
      t.string :content_type
      t.integer :size
      t.integer :parent_id
      t.string :thumbnail
      t.integer :user_id
    end
  end

  def self.down
    drop_table :user_images
  end
end
