class CreateLabMobileCourses < ActiveRecord::Migration
  def change
    create_table :lab_mobile_courses do |t|
      t.string :name
      t.integer :author
      t.integer :course_type
      t.integer :status

      t.timestamps
    end
  end
end
