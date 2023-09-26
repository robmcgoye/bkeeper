class DropTablePayouts < ActiveRecord::Migration[7.0]
  def up
    drop_table :payouts
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
