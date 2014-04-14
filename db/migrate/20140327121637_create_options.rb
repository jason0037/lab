class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.string :key
      t.integer :index
      t.string :name
      t.string :value
      t.string :desc

      t.timestamps
    end
  end
end
