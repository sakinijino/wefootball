class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.text :content
      t.string :subject
      t.boolean :is_delete_by_sender, :default=>false
      t.boolean :is_delete_by_receiver, :default=>false
      t.boolean :is_receiver_read, :default=>false
      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
