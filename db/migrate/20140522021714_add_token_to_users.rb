class AddTokenToUsers < ActiveRecord::Migration
  def up
    add_column :lab_users, :reset_token, :string
  end

  def down
    remove_column :lab_users,:reset_token
  end
end
