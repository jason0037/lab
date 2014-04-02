class CreateLabDeviceSupports < ActiveRecord::Migration
  def change
    create_table :lab_device_supports do |t|
      t.integer :device_id
      t.integer :rel_id
      t.integer :type

      t.timestamps
    end
  end
end
