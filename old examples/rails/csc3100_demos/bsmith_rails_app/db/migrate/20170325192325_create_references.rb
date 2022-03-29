class CreateReferences < ActiveRecord::Migration[5.0]
  def change
    create_table :references do |t|
      t.integer :owner
      t.string :reference_name
      t.string :reference_contact_info

      t.timestamps
    end
  end
end
