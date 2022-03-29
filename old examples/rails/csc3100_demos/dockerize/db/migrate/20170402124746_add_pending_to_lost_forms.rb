class AddPendingToLostForms < ActiveRecord::Migration[5.0]
  def change
    add_column :lost_forms, :pending, :string, default:false
  end
end
