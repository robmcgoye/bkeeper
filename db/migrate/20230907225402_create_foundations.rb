class CreateFoundations < ActiveRecord::Migration[7.0]
  def change
    create_table :foundations do |t|
      t.string :short_name
      t.string :long_name

      t.timestamps
    end
  end
end
