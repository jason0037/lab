class CreateLabNotices < ActiveRecord::Migration
  def change
    create_table :lab_notices do |t|
      t.string :title
      t.text :body
      t.integer :cat_id
      t.datetime :published_at
      t.integer :notice_type
      t.boolean :published

      t.timestamps
    end
  end
end
