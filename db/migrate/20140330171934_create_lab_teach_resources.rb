class CreateLabTeachResources < ActiveRecord::Migration
  def change
    create_table :lab_teach_resources do |t|
      t.string :title
      t.string :file
      t.integer :author
      t.integer :course_type
      t.integer :status
      t.string :brief

      t.timestamps
    end
  end
end
