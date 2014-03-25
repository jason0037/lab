class CreateLabReports < ActiveRecord::Migration
  def change
    create_table :lab_reports do |t|
      t.string :name
      t.string :desc
      t.integer :parent_report_id
      t.integer :child_report_index

      t.timestamps
    end
  end
end
