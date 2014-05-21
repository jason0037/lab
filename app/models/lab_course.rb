# encoding: utf-8
class LabCourse < ActiveRecord::Base
  attr_accessible :apply_time, :approve_time, :before, :category_id, :course_property,
                  :desc, :end_time, :is_teach, :name, :progress, :publish_time, :project_id,
                  :start_time, :status, :scene_id, :teacher_id, :course_type
  has_many :lab_eval_projects

  belongs_to :lab_user,:foreign_key=>"teacher_id"
  belongs_to :lab_scene,:foreign_key=>"scene_id"
end
