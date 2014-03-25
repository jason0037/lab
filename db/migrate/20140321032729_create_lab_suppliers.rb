class CreateLabSuppliers < ActiveRecord::Migration
  def change
    create_table :lab_suppliers do |t|
      t.string :name
      t.string :tel
      t.string :addr
      t.string :contacts

      t.timestamps
    end
  end
end
