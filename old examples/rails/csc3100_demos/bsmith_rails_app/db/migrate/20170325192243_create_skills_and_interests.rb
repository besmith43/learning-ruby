class CreateSkillsAndInterests < ActiveRecord::Migration[5.0]
  def change
    create_table :skills_and_interests do |t|
      t.integer :owner
      t.string :skill_name
      t.string :skill_description

      t.timestamps
    end
  end
end
