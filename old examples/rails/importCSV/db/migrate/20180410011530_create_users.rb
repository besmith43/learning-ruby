class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.integer :steps
      t.float :distance
      t.integer :exercise
      t.float :sleep
      t.integer :calories

      t.timestamps
    end
  end
end
