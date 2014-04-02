class CreateLabCats < ActiveRecord::Migration
  def change
    create_table :lab_cats do |t|
      t.integer :parent_id
      t.string :cat_name
      t.integer :disabled

      t.timestamps
    end
  end
end
