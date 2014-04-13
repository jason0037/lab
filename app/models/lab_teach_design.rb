# encoding: utf-8
class LabTeachDesign < ActiveRecord::Base
  attr_accessible :author_id,:course_type,:file,:title,:status,:brief

  belongs_to :lab_user,:foreign_key=>"author_id"
  validates :title, :presence=>{:presence=>true,:message=>"请填写标题."}
  validates :course_type, :presence=>{:presence=>true,:message=>"请选择学科类别."}
  validates :brief, :presence=>{:presence=>true,:message=>"请填写简介."}
end
