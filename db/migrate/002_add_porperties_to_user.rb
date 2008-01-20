class AddPorpertiesToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :nickname, :string
    add_column :users, :height, :float
    add_column :users, :weight, :float
    add_column :users, :fitfoot, :string, :limit=>1
    add_column :users, :birthday, :date
    add_column :users, :summary, :text
  end

  def self.down
    remove_column :users, :nickname
    remove_column :users, :height
    remove_column :users, :weight
    remove_column :users, :birthday
    remove_column :users, :fitfoot
    remove_column :users, :summary
  end
end
