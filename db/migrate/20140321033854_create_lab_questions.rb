class CreateLabQuestions < ActiveRecord::Migration
  def change
    create_table :lab_questions do |t|
      t.string :desc
      t.integer :question_category
      t.string :version
      t.integer :questionnaire_id
      t.integer :question_type
      t.integer :weight
      t.integer :score
      t.string :options

      t.timestamps
    end
  end
end
