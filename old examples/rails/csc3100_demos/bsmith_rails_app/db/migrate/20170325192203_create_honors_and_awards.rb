class CreateHonorsAndAwards < ActiveRecord::Migration[5.0]
  def change
    create_table :honors_and_awards do |t|
      t.integer :owner
      t.string :honor_date
      t.string :honor_name
      t.string :honor_description

      t.timestamps
    end
  end
end
