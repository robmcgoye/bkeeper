class RemoveCols < ActiveRecord::Migration[7.0]
  def change
    remove_column :grants, :grant_number
    remove_column :grants, :granted_at
    remove_reference :payouts, :commitment, index: true, foreign_key: true
    add_reference :payouts, :grant, index: true, foreign_key: true
  end
end
