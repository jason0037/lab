class CreateLabCourseStudents < ActiveRecord::Migration
  def change
    create_table :lab_course_students do |t|
      t.string :course_id
      t.integer :user_id
      t.integer :status

      t.timestamps
    end
  end
end
