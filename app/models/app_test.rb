# encoding: utf-8
class AppTest < ActiveRecord::Base
  attr_accessible :user_id, :test_id, :score, :deviceType, :version

  belongs_to :lab_user,:foreign_key=>"user_id"

end
