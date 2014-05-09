# encoding: utf-8
class LabUser < ActiveRecord::Base
  attr_accessible :account, :email, :mobile, :name, :password, :role_id, :status

  belongs_to :lab_role,:foreign_key=>"role_id"

  has_many :lab_questions_score, :foreign_key=>"evaluator_id"
  has_many :lab_eval_project,:foreign_key=>"applicant_id"
  has_many :lab_teach_resource,:foreign_key=>"author_id"
  has_many :lab_teach_design,:foreign_key=>"author_id"
  has_many :lab_mobile_course,:foreign_key=>"author_id"


  validates :account, :presence=>{:presence=>true,:message=>"请填写用户名."}
  validates :password, :presence=>{:presence=>true,:message=>"请填写密码."}
  validates :role_id, :presence=>{:presence=>true,:message=>"请选择用户类型."}


  def status_text
    text = "未审核"
    if self.status == 1
      text = "已审核"
    end
    text
  end
  #after_save :sync_edx_user

end
