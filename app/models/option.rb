# encoding: utf-8
class Option < ActiveRecord::Base
  attr_accessible :index, :key, :name, :value
  has_many :lab_eval_projects, :foreign_key=>"course_type"
  has_many :lab_eval_projects, :foreign_key=>"category_id"

  def course_type(course_type)
    self.where(:key=>"course_type",:value=>course_type).value
  end

  def eval_object_type(category_id)
    self.where(:key=>"eval_object_type",:value=>category_id).value
  end
end
