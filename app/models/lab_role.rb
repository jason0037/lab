# encoding: utf-8
class LabRole < ActiveRecord::Base
  attr_accessible :name,:path

  has_many :lab_user,:foreign_key=>"role_id"
end
