class CreateEquipmentMapping < ActiveRecord::Migration
  def up
  	create_table :lab_equipment_mappings do |t|
      t.string :equipment_code
      t.string :table_name
      t.integer :status

      t.timestamps
    end
  end

  def down
  end
end
