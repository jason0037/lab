class CreateLabQuestionnaires < ActiveRecord::Migration
  def change
    create_table :lab_questionnaires do |t|
      t.string :title
      t.string :desc
      t.string :version
      t.integer :status

      t.timestamps
    end
  end
end
