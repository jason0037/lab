# encoding: utf-8
class LabUser < ActiveRecord::Base
  attr_accessible :account, :email, :mobile, :name, :password, :role_id, :status

  has_one :lab_role,:foreign_key=>"id"

  validates :account, :presence=>{:presence=>true,:message=>"请填写用户名."}
  validates :password, :presence=>{:presence=>true,:message=>"请填写密码."}
  validates :role_id, :presence=>{:presence=>true,:message=>"请选择用户类型."}

end
