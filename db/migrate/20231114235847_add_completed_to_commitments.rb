class AddCompletedToCommitments < ActiveRecord::Migration[7.1]
  def change
    add_column :commitments, :completed, :boolean, default: false
  end
end
