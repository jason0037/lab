class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authorize_user!

  def authorize_user!
	if cookies[:lab_member_id].blank? || cookies[:lab_login].blank?
		redirect_to login_lab_users_path
		return
	else
		@user = LabUser.find(cookies[:lab_member_id])
		check_key = "_m_lab" + @user.password
		if !Digest::MD5.hexdigest(check_key) == cookies[:lab_login]
			redirect_to login_lab_users_path
			return
		end
	end
  end
end
