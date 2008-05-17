class AddWatchJoinCountColumns < ActiveRecord::Migration
  def self.up
    add_column :official_matches, :watch_count, :integer, :default=>0
    add_column :official_matches, :watch_join_count, :integer, :default=>0
    add_column :watches, :watch_join_count, :integer, :default=>0
  end

  def self.down
    remove_column :official_matches, :watch_count
    remove_column :official_matches, :watch_join_count
    remove_column :watches, :watch_join_count
  end
end
