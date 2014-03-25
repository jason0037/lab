class CreateLabEvalProjects < ActiveRecord::Migration
  def change
    create_table :lab_eval_projects do |t|
      t.string :name
      t.string :version
      t.integer :categery_id
      t.integer :course_type
      t.integer :scene_id
      t.integer :status
      t.integer :supplier_id

      t.timestamps
    end
  end
end
