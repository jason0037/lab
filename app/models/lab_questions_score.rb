# encoding: utf-8
class LabQuestionsScore < ActiveRecord::Base
  attr_accessible :project_id, :question_id, :score,:importance,:evaluator_id

  belongs_to :lab_user, :foreign_key=>"evaluator_id"
  belongs_to :lab_eval_project,:foreign_key=>"porject_id"
end
