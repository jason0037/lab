class CreateLabRoles < ActiveRecord::Migration
  def change
    create_table :lab_roles do |t|
      t.string :name
      t.string :path

      t.timestamps
    end
  end
end
