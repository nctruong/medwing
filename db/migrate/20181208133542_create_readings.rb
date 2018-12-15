class CreateReadings < ActiveRecord::Migration[5.1]
  def change
    create_table :readings do |t|
      t.integer :number
      t.float :temperature
      t.float :humidity
      t.float :battery_charge

      t.belongs_to :thermostat
      t.timestamps
    end
  end
end
