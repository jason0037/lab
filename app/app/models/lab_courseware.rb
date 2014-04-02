class LabCourseware < ActiveRecord::Base
  attr_accessible :course_id, :download_times, :download_url, :file_size, :name, :play_time, :product_time, :productor_id, :publish_time, :type
end
