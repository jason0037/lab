class CreateLabTeachDesigns < ActiveRecord::Migration
  def change
    create_table :lab_teach_designs do |t|
      t.string :name
      t.string :file
      t.integer :author
      t.integer :course_type
      t.integer :status

      t.timestamps
    end
  end
end
