class LabData < ActiveRecord::Base
 # set_table_name "B000001_reading"
  attr_accessible :id, :value, :source, :read_at, :saved_at, :point_id
end
