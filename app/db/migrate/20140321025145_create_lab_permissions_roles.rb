class CreateLabPermissionsRoles < ActiveRecord::Migration
  def change
    create_table :lab_permissions_roles do |t|
      t.integer :role_id
      t.integer :permission_id

      t.timestamps
    end
  end
end
