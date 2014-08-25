# encoding: utf-8
class LabQuestion < ActiveRecord::Base
  attr_accessible :desc, :question_category,:questionnaire_id,:question_type, :weight,:score,:options

  belongs_to :lab_questionnaire ,:foreign_key=>'questionnaire_id'

end
