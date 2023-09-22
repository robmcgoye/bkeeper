class FixRelations < ActiveRecord::Migration[7.0]
  def change
    remove_reference :payouts, :register, index: true, foreign_key: true
    add_reference :payouts, :commitment, index: true, foreign_key: true    
  end
end
