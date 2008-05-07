class CreateBroadcasts < ActiveRecord::Migration
  def self.up
    create_table :broadcasts do |t|
      t.column :type, :string
      t.column :user_id, :integer
      t.column :friend_id, :integer
      t.column :team_id, :integer
      t.column :activity_id, :integer
      t.column :text, :text
      t.timestamps
    end
  end

  def self.down
    drop_table :broadcasts
  end
end
