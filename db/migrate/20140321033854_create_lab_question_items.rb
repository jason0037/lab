class CreateLabQuestionItems < ActiveRecord::Migration
  def change
    create_table :lab_question_items do |t|
      t.string :desc
      t.integer :question_id
      t.integer :item_index

      t.timestamps
    end
  end
end
