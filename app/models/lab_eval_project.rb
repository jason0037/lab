# encoding: utf-8
class LabEvalProject < ActiveRecord::Base
  attr_accessible :name,:version,:category_id,:course_type,:scene_id,:status,:supplier_id,:applicant_id,:brief,:status_log,:eval_means,:unit
  belongs_to :lab_user,:foreign_key=>"applicant_id"
  belongs_to :lab_supplier,:foreign_key=>"supplier_id"
  belongs_to :lab_scene,:foreign_key=>"scene_id"
  belongs_to :option,:foreign_key=>"course_type"
  belongs_to :option,:foreign_key=>"category_id"

  has_many :lab_questions_score,:foreign_key=>"project_id"

  has_many :lab_courses,:foreign_key=>"project_id"

  def has_eval_means_of(value=nil)
    # add function later
    return true
  end

end
