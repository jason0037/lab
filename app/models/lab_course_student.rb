# encoding: utf-8
class LabCourseStudent < ActiveRecord::Base
  attr_accessible :course_id, :status, :user_id
end
