# encoding: utf-8
class LabCourse < ActiveRecord::Base
  attr_accessible :apply_time, :approve_time, :before, :category_id, :course_property,
                  :desc, :end_time, :need_teach, :name, :progress, :publish_time, :project_id,
                  :start_time, :status, :scene_id, :teacher_id, :course_type,:location, :participants
  belongs_to :lab_eval_project,:foreign_key=>"project_id"

  belongs_to :lab_user,:foreign_key=>"teacher_id"
  belongs_to :lab_scene,:foreign_key=>"scene_id"
end
