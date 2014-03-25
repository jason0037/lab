class CreateLabDevices < ActiveRecord::Migration
  def change
    create_table :lab_devices do |t|
      t.string :name
      t.string :version

      t.timestamps
    end
  end
end
