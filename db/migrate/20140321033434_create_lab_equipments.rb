class CreateLabEquipments < ActiveRecord::Migration
  def change
    create_table :lab_equipments do |t|
      t.string :name
      t.string :equipment_code
      t.string :position
      t.integer :status
      t.datetime :install_time

      t.timestamps
    end
  end
end
