class CreateOfficialMatchEditors < ActiveRecord::Migration
  def self.up
    create_table :official_match_editors, :id => false do |t|
      t.integer :user_id
    end
    add_index :official_match_editors, :user_id
  end

  def self.down
    drop_table :official_match_editors
  end
end
