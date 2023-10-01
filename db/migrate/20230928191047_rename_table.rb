class RenameTable < ActiveRecord::Migration[7.0]
  def change
    rename_table :grants, :contributions
    add_column :contributions, :in_kind, :integer
    add_monetize :contributions, :non_deductible, currency: { present: false }
    change_column :contributions, :non_deductible_cents, :integer, limit: 8
    add_column :contributions, :non_deductible_check_on, :datetime
    add_column :contributions, :non_deductible_check_number, :string
  end
end
