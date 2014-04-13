# encoding: utf-8
class LabQuestion < ActiveRecord::Base
  attr_accessible :answer_id, :question, :report_id, :report_index
end
