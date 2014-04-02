class CreateLabPermissions < ActiveRecord::Migration
  def change
    create_table :lab_permissions do |t|
      t.string :name
      t.string :key
      t.string :url

      t.timestamps
    end
  end
end
