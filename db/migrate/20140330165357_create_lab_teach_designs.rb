class CreateLabTeachDesigns < ActiveRecord::Migration
  def change
    create_table :lab_teach_designs do |t|
      t.string :title
      t.string :file
      t.integer :author_id
      t.integer :course_type
      t.integer :status
      t.string :brief

      t.timestamps
    end
  end
end
