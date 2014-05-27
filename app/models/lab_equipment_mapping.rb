class LabEquipmentMapping < ActiveRecord::Base
  attr_accessible :equipment_code, :table_name, :status

  def self.get_table_name(equipment_code)
	dc = Dalli::Client.new('localhost:11211',{:namespace => "lab_v1", :compress => true})
	if dc.get(equipment_code).blank?
		table_name = LabEquipmentMapping.find_by_equipment_code(equipment_code).table_name
		dc.set(equipment_code,table_name)
	else
		table_name = dc.get(equipment_code)
	end
	return table_name
  end
end
