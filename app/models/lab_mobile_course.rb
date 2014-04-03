class LabMobileCourse < ActiveRecord::Base
  attr_accessible :author_id,:course_type,:file,:title,:status,:brief
  belongs_to :lab_user,:foreign_key=>"author_id"
end
