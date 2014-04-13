# encoding: utf-8
class LabCourse < ActiveRecord::Base
  attr_accessible :apply_time, :approve_time, :before, :category_id, :course_property, :desc, :end_time, :is_teach, :name, :progress, :publish_time, :report_id, :start_time, :status, :style, :teacher_id, :type
  has_many :lab_eval_projects
end
