class CreateLabCourses < ActiveRecord::Migration
  def change
    create_table :lab_courses do |t|
      t.string :name
      t.integer :category_id
      t.integer :type
      t.integer :teacher_id
      t.datetime :start_time
      t.datetime :end_time
      t.integer :status
      t.integer :project_id
      t.integer :progress
      t.datetime :publish_time
      t.datetime :apply_time
      t.string :approve_time
      t.integer :style
      t.integer :course_property
      t.integer :is_teach
      t.integer :before
      t.integer :desc

      t.timestamps
    end
  end
end
