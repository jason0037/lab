class CreateLabEvalProjects < ActiveRecord::Migration
  def change
    create_table :lab_eval_projects do |t|
      t.string :name
      t.string :version
      t.integer :category_id
      t.integer :course_type
      t.integer :scene_id
      t.integer :status
      t.integer :supplier_id
      t.integer :applicant_id
      t.string :eval_means
      t.string :brief
      t.string :status_log
      t.timestamps
    end
  end
end
