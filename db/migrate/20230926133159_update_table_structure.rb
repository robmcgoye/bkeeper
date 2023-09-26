class UpdateTableStructure < ActiveRecord::Migration[7.0]
  def change
    add_reference :commitments, :grant, index: true
    change_column :commitments, :amount_cents, :integer, limit: 8
    change_column :reconciliations, :starting_balance_cents, :integer, limit: 8
    change_column :reconciliations, :ending_balance_cents, :integer, limit: 8
    change_column :registers, :amount_cents, :integer, limit: 8
    remove_index :payouts, :commitment_id
    # "index_payouts_on_commitment_id"
    remove_index :payouts, :grant_id
    # "index_payouts_on_grant_id"
    remove_foreign_key :payouts, :commitments
    remove_foreign_key :payouts, :grants

  end
end
