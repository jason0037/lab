# encoding: utf-8
class LabSupplier < ActiveRecord::Base
  attr_accessible :addr, :contacts, :name, :tel
  has_many :lab_eval_projects,:foreign_key=>"supplier_id"
end
