class CreateLabCoursewares < ActiveRecord::Migration
  def change
    create_table :lab_coursewares do |t|
      t.string :name
      t.integer :course_id
      t.integer :productor_id
      t.integer :type
      t.string :play_time
      t.string :file_size
      t.datetime :product_time
      t.string :download_url
      t.string :download_times
      t.datetime :publish_time

      t.timestamps
    end
  end
end
