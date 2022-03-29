class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
      t.integer :section_id
      t.integer :user_id
      t.text :body
      t.integer :order
      t.boolean :is_published
      t.boolean :menu_display

      t.timestamps
    end
  end
end
