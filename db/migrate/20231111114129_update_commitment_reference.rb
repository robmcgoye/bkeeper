class UpdateCommitmentReference < ActiveRecord::Migration[7.1]
  def change
    remove_index :commitments, :contribution_id
    remove_column :commitments, :contribution_id
    add_reference :contributions, :commitment, index: true, null: true
  end
end
