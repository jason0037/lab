# encoding: utf-8
class LabDataMinute < ActiveRecord::Base
  attr_accessible :read_at, :attention, :meditation,:behaviour,:network_up,:network_down,:energy_consumption,:temperature,:humidity
end
