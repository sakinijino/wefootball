class CreateOfficalMatchEditors < ActiveRecord::Migration
  def self.up
    create_table :offical_match_editors, :id => false do |t|
      t.integer :user_id
    end
    add_index :offical_match_editors, :user_id
  end

  def self.down
    drop_table :offical_match_editors
  end
end
