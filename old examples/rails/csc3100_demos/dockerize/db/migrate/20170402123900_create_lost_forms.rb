class CreateLostForms < ActiveRecord::Migration[5.0]
  def change
    create_table :lost_forms do |t|
      t.date :current_date
      t.date :lost_date
      t.string :phone
      t.string :owner_name
      t.string :pet_name
      t.string :collar
      t.string :tags
      t.string :color
      t.string :species
      t.string :breed
      t.string :gender
      t.string :size
      t.string :spayed_neutered
      t.text :found
      t.text :comments

      t.timestamps
    end
  end
end
