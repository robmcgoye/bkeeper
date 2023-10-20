class RenameRegistersTable < ActiveRecord::Migration[7.0]
  def change
    rename_table :registers, :checks
    rename_column :contributions, :register_id, :check_id
    rename_column :reconciliation_items, :register_id, :check_id
  end
end
