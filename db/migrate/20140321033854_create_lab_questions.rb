class CreateLabQuestions < ActiveRecord::Migration
  def change
    create_table :lab_questions do |t|
      t.string :desc
      t.integer :question_category
      t.string :version

      t.timestamps
    end
  end
end
