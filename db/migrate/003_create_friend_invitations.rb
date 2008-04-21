class CreateFriendInvitations < ActiveRecord::Migration
  def self.up
    create_table :friend_invitations do |t|
      t.integer :applier_id
      t.integer :host_id
      t.text :message, :limit=>150
      t.date :apply_date
    end
  end

  def self.down
    drop_table :friend_invitations
  end
end
