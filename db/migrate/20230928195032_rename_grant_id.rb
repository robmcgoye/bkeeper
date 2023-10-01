class RenameGrantId < ActiveRecord::Migration[7.0]
  def change
    rename_column :commitments, :grant_id, :contribution_id
  end
end
