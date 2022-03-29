class AddProfileDataToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :t_number, :string
    add_column :users, :college, :string
    add_column :users, :department, :string
    add_column :users, :rank, :string
    add_column :users, :rank_date, :date
    add_column :users, :tenure_date, :date
  end
end
