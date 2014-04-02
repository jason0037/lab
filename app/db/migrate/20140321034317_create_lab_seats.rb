class CreateLabSeats < ActiveRecord::Migration
  def change
    create_table :lab_seats do |t|
      t.integer :course_id
      t.integer :seat_index
      t.integer :user_id

      t.timestamps
    end
  end
end
