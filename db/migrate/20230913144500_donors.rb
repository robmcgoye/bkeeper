class Donors < ActiveRecord::Migration[7.0]
  def change

    create_table :donors do |t|
      t.string :code
      t.string :full_name
      t.references :foundation, null: false, foreign_key: true

      t.timestamps
    end

    create_table :funding_sources do |t|
      t.string :code
      t.string :short_name
      t.string :full_name
      t.references :foundation, null: false, foreign_key: true

      t.timestamps
    end

    create_table :bank_accounts do |t|
      t.string :full_name
      t.boolean "primary", null: false, default: false
      t.references :foundation, null: false, foreign_key: true

      t.timestamps
    end

    create_table :organization_types do |t|
      t.string :code
      t.string :description
      t.references :foundation, null: false, foreign_key: true

      t.timestamps
    end

    create_table :organizations do |t|
      t.string :name
      t.string :alpha
      t.string :tax_number
      t.string :contact
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :zip
      t.string :country

      t.references :foundation, null: false, foreign_key: true
      t.references :organization_type, null: false, foreign_key: true

      t.timestamps
    end
    
  end
end
