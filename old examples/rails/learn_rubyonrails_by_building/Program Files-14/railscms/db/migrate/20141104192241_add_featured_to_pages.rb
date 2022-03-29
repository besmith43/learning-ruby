class AddFeaturedToPages < ActiveRecord::Migration
  def change
    add_column :pages, :featured, :boolean
  end
end
