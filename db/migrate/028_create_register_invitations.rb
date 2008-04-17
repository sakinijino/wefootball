class CreateRegisterInvitations < ActiveRecord::Migration
  def self.up
    create_table :register_invitations do |t|
      t.string :login
      t.text :message
      t.string :invitation_code, :limit=>40
      t.timestamps
    end
  end

  def self.down
    drop_table :register_invitations
  end
end
