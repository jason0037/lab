# encoding: utf-8
class LabDevice < ActiveRecord::Base
  attr_accessible :name, :version,:brand,:device_type,:cost,:bn,:photo,:supplier,:status,:assets_no
end
