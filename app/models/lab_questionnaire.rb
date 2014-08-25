# encoding: utf-8
class LabQuestionnaire < ActiveRecord::Base
  attr_accessible :desc, :title,:version,:status

  has_many :lab_questions, :foreign_key=>'questionnaire_id'

end
