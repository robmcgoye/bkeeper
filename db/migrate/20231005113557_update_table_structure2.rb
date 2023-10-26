class UpdateTableStructure2 < ActiveRecord::Migration[7.0]
  def change
    change_column :registers, :check_number, 'integer USING CAST(check_number AS integer)'
    remove_index :registers, :reconciliation_id
    remove_foreign_key :registers, :reconciliations
    remove_column :registers, :reconciliation_id

    create_table :reconciliation_items do |t|
      t.references :reconciliation, foreign_key: true, null: false
      t.references :register, foreign_key: true, null: false

      t.timestamps
    end

  end
end
