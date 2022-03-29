class AddDetailsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :major, :string
    add_column :users, :degree_program, :string
    add_column :users, :department, :string
    add_column :users, :year_started, :integer
  end
end
