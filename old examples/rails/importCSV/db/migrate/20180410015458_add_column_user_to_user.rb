class AddColumnUserToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :user, :string
  end
end
