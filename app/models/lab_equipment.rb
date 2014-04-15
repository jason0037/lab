# encoding: utf-8
class LabEquipment < ActiveRecord::Base
  attr_accessible :equipment_code, :install_time, :name, :position, :status

  belongs_to :lab_equipment_mapping,:foreign_key=>"equipment_code"
end
