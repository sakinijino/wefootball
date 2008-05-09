class AddInvitationsCountColumns < ActiveRecord::Migration
  def self.up
    add_column :users, :friend_invitations_count, :integer, :default=>0
    add_column :users, :team_join_invitations_count, :integer, :default=>0
    add_column :teams, :team_join_requests_count, :integer, :default=>0
    add_column :teams, :match_invitations_count, :integer, :default=>0
    
    Team.find(:all).each do |t|
      t.team_join_requests_count = TeamJoinRequest.count :conditions => ["team_id = ? and is_invitation = ?", t.id, false]
      t.match_invitations_count = MatchInvitation.count :conditions=>[
        "(host_team_id = ? and edit_by_host_team = ?) or (guest_team_id = ? and edit_by_host_team = ?)", 
        t.id, true, t.id, false]
      t.save!
    end 
    # there are some bugs, and teams' counts can not be refreshed correctly. Please run these aboving codes manually.
    User.find(:all).each do |u|
      u.friend_invitations_count = FriendInvitation.count :conditions => ["host_id = ?", u.id]
      u.team_join_invitations_count = TeamJoinRequest.count :conditions => ["user_id = ? and is_invitation = ?", u.id, true]
      u.save!
    end
  end

  def self.down
    remove_column :users, :friend_invitations_count
    remove_column :users, :team_join_invitations_count
    remove_column :teams, :team_join_requests_count
    remove_column :teams, :match_invitations_count
  end
end
