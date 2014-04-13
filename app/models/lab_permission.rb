# encoding: utf-8
class LabPermission < ActiveRecord::Base
  attr_accessible :key, :name, :url
end
