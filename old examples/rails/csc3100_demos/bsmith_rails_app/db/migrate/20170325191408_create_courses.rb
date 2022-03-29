class CreateCourses < ActiveRecord::Migration[5.0]
  def change
    create_table :courses do |t|
      t.integer :owner
      t.string :course_number
      t.string :course_name

      t.timestamps
    end
    add_index :courses, :owner
  end
end
