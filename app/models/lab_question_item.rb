# encoding: utf-8
class LabQuestionItem < ActiveRecord::Base
  attr_accessible :desc, :item_index, :question_id
end
