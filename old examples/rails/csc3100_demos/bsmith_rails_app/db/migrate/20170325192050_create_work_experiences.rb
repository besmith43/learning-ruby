class CreateWorkExperiences < ActiveRecord::Migration[5.0]
  def change
    create_table :work_experiences do |t|
      t.integer :owner
      t.string :start_date
      t.string :end_date
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
