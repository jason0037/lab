class CreateLabUsers < ActiveRecord::Migration
  def change
    create_table :lab_users do |t|
      t.string :name
      t.string :mobile
      t.string :email
      t.string :account
      t.string :password
      t.integer :role_id
      t.integer :status

      t.timestamps
    end
  end
end
