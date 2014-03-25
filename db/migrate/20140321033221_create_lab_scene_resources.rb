class CreateLabSceneResources < ActiveRecord::Migration
  def change
    create_table :lab_scene_resources do |t|
      t.string :name
      t.integer :type
      t.integer :play_type
      t.integer :play_idle

      t.timestamps
    end
  end
end
