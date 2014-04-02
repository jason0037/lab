class LabTeachResource < ActiveRecord::Base
  attr_accessible :author, :course_type, :name, :status
end
