class AddUnReadMessageCount < ActiveRecord::Migration
  def self.up
    add_column :users, :unread_messages_count, :integer, :default=>0
    User.find(:all).each do |u|
      u.unread_messages_count = Message.count :conditions => ["receiver_id = ? and is_receiver_read = ?", u.id, false]
      u.save!
    end
  end

  def self.down
    remove_column :users, :unread_messages_count
  end
end
