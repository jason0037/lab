class LabNotice < ActiveRecord::Base
  attr_accessible :body, :cat_id, :published, :published_at, :title,:notice_type

end
