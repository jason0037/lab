class LabScene < ActiveRecord::Base
  attr_accessible :desc, :limit, :name, :secens_resource_id
  has_many :lab_eval_projects,:foreign_key=>"scene_id"
end
