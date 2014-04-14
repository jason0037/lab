class CreateLabQuestionsScores < ActiveRecord::Migration
  def change
    create_table :lab_questions_scores do |t|
      t.integer :project_id
      t.string :question_importance_score
      t.integer :total
      t.integer :evaluator_id

      t.timestamps
    end
  end
end
