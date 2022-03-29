class CreatePetForms < ActiveRecord::Migration[5.0]
  def change
    create_table :pet_forms do |t|
      t.datetime :date
      t.datetime :date_since
      t.integer :phone
      t.string :owner_name
      t.string :pet_name
      t.string :color
      t.string :collar
      t.string :tags
      t.string :breed
      t.string :gender
      t.string :size
      t.boolean :spayed_neutered
      t.text :area
      t.text :comments
      t.boolean :lost_found
      t.boolean :pending

      t.timestamps
    end
  end
end
