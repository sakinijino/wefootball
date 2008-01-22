class CreateTrainingJoins < ActiveRecord::Migration
  def self.up
    create_table :training_joins do |t|
      t.integer :user_id
      t.integer :training_id
    end
  end

  def self.down
    drop_table :training_joins
  end
end
