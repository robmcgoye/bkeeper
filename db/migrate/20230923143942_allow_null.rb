class AllowNull < ActiveRecord::Migration[7.0]
  def change
    change_column_null :registers, :reconciliation_id, true
  end
end
