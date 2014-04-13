# encoding: utf-8
class LabSeat < ActiveRecord::Base
  attr_accessible :course_id, :seat_index, :user_id
end
