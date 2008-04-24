class CreateUnRegFriendInvs < ActiveRecord::Migration
  def self.up
    create_table :un_reg_friend_invs do |t|
      t.integer :user_id
      t.integer :invitation_id
      t.integer :host_id      
    end
    RegisterInvitation.find(:all).each do |item|
      UnRegFriendInv.create!(:invitation_id=>item.id,:host_id=>item.host_id)
    end
    FriendInvitation.find(:all, :conditions=>["users.activated_at is null"], :include=>[:applier]).each do |item|
      UnRegFriendInv.create!(:user_id=>item.applier_id,:host_id=>item.host_id)
      item.destroy
    end    
    remove_column :register_invitations, :host_id     
  end

  def self.down
    drop_table :un_reg_friend_invs
    add_column :register_invitations, :host_id, :integer 
  end
end
