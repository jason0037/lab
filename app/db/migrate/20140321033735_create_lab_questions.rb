class CreateLabQuestions < ActiveRecord::Migration
  def change
    create_table :lab_questions do |t|
      t.string :question
      t.integer :report_id
      t.integer :report_index
      t.integer :answer_id

      t.timestamps
    end
  end
end
