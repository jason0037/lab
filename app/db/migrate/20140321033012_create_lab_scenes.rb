class CreateLabScenes < ActiveRecord::Migration
  def change
    create_table :lab_scenes do |t|
      t.string :name
      t.string :limit
      t.string :desc
      t.integer :secens_resource_id

      t.timestamps
    end
  end
end
