class LabEquipment < ActiveRecord::Base
  attr_accessible :equipment_code, :install_time, :name, :position, :status
end
