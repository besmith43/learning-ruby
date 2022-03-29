class AddCoverpathToBooks < ActiveRecord::Migration
  def change
    add_column :books, :coverpath, :string
  end
end
