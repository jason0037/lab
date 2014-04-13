# encoding: utf-8
class LabReport < ActiveRecord::Base
  attr_accessible :child_report_index, :desc, :name, :parent_report_id
end
