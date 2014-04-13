# encoding: utf-8
class LabDeviceSupport < ActiveRecord::Base
  attr_accessible :device_id, :rel_id, :type
end
