class AddSecretToUsers < ActiveRecord::Migration
  def up
    add_column :lab_users, :secret_key, :string
  end

  def down
    remove_column :lab_users,:secret_key
  end
end
