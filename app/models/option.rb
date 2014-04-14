# encoding: utf-8
class Option < ActiveRecord::Base
  attr_accessible :index, :key, :name, :value, :desc
  has_many :lab_eval_projects, :foreign_key=>"course_type"
  has_many :lab_eval_projects, :foreign_key=>"category_id"

  scope :course_type, -> { where(key: "course_type") }
  scope :category, -> { where(key: "eval_object_type") }
  scope :question_category, -> { where(key: "question_category") }
  scope :eval_means, -> { where(key: "eval_means") }
  scope :notice_type,->{ where(key: "notice_type")}
  scope :eval_status, -> { where(key: "eval_status") }

  def course_type(course_type)
    self.where(:key=>"course_type",:value=>course_type).value
  end

  def eval_object_type(category_id)
    self.where(:key=>"eval_object_type",:value=>category_id).value
  end
end
