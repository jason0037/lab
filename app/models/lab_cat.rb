# encoding: utf-8
class LabCat < ActiveRecord::Base
  attr_accessible :cat_name, :disabled, :parent_id
end
