# encoding: utf-8
class LabDevice < ActiveRecord::Base
  attr_accessible :name, :version
end
