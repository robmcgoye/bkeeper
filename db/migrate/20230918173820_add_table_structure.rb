class AddTableStructure < ActiveRecord::Migration[7.0]
  def change
    add_monetize :bank_accounts, :starting_balance, currency: { present: false }
    add_monetize :bank_accounts, :balance, currency: { present: false }

    create_table :reconciliations do |t|
      t.datetime :started_at
      t.datetime :ended_at
      t.monetize :starting_balance
      t.monetize :ending_balance

      t.references :bank_account, null: false, foreign_key: true
      t.timestamps      
    end

    create_table :registers do |t|
      t.string :check_number
      t.datetime :transaction_at
      t.integer :transaction_type
      t.string :description
      t.monetize :amount
      t.boolean :cleared, null: false, default: false

      t.references :reconciliation, null: false, foreign_key: true
      t.references :bank_account, null: false, foreign_key: true      
      t.timestamps      
    end

    create_table :grants do |t|
      t.string :grant_number
      t.datetime :granted_at
      t.string :note

      t.references :donor, null: false, foreign_key: true
      t.references :funding_source, null: false, foreign_key: true
      t.references :register, null: false, foreign_key: true
      t.references :organization, null: false, foreign_key: true
      t.timestamps      
    end

    create_table :commitments do |t|
      t.string :code
      t.integer :number_payments
      t.monetize :amount
      t.datetime :start_at
      t.datetime :end_at

      t.references :organization, null: false, foreign_key: true
      t.timestamps      
    end
    
    create_table :payouts do |t|
      t.timestamps      
      t.references :register, null: false, foreign_key: true
      t.references :commitment, null: false, foreign_key: true
    end

  end
end
