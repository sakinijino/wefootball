class AddPorpertiesToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :nickname, :string, :limit=>15
    add_column :users, :birthday, :date
    add_column :users, :summary, :text
    add_column :users, :favorite_star, :string, :limit=>100, :default=>''
    add_column :users, :favorite_team, :string, :limit=>100, :default=>''
    add_column :users, :is_playable, :boolean, :default=>false
    add_column :users, :height, :float
    add_column :users, :weight, :float
    add_column :users, :fitfoot, :string, :limit=>1
    add_column :users, :premier_position, :string, :limit=>2
  end

  def self.down
    remove_column :users, :nickname
    remove_column :users, :birthday
    remove_column :users, :summary
    remove_column :users, :favorite_star
    remove_column :users, :favorite_team
    remove_column :users, :is_playable
    remove_column :users, :height
    remove_column :users, :weight
    remove_column :users, :fitfoot
    remove_column :users, :premier_position
  end
end
