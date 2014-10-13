# encoding: utf-8
require 'pp'

class LabUsersController < ApplicationController
  before_filter :authorize_user!,:except => [:login,:login_in,:new,:create,:home,:forgot_pass,:pass_change,:reset_pass,:modify_pass]

  #layout "blank"

  # GET /lab_users
  # GET /lab_users.json
  def search
    @action='/lab_users/0/search'
    @key=params[:key]

    @lab_users =  LabUser.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")
    if @key
      @lab_users =@lab_users.where("name like '%#{@key}%'")
    end
    render 'lab_users/index',:layout => "blank"
  end

  def index
    @action='/lab_users/0/search'
    @lab_users = LabUser.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")

    render :layout => "blank"
  end

  def query
    if params[:s].blank?
      @query_text = ""
      @lab_users = LabUser.where(:role_id=>5).paginate(:page => params[:page], :per_page => 5).order("created_at DESC")
    else
      @query_text = params[:s][:name]
      @lab_users = LabUser.where("role_id = ? and name like ?",5,"%#{params[:s][:name]}%").paginate(:page => params[:page], :per_page => 5).order("created_at DESC")
    end

    render :layout => "blank"
  end

  def pass_change
    if params[:lab_user][:email].blank?
      redirect_to forgot_pass_lab_users_path, :notice => "请输入EMAIL."
      return
    else
      @user = LabUser.find_by_email(params[:lab_user][:email])
      if @user.blank?
        redirect_to forgot_pass_lab_users_path, :notice => "EMAIL不存在."
      else
        @token = SecureRandom.hex 20
        @user.reset_token = @token
        result = SendMail.send_mail params[:lab_user][:email],@token,@user.id
        @user.save
      end
    end
    redirect_to login_lab_users_path, :notice => "已经发送重置邮件到您的邮箱."
  end

  def reset_pass
    @user = LabUser.find(params[:id])

    if @user.reset_token != params[:reset_token]
      redirect_to login_lab_users_path, :notice => "重置参数不正确，请重新操作."
      return
    end
    render :layout => "home"
  end

  def modify_pass
    @user = LabUser.find(params[:lab_user][:user_id])
    if params[:lab_user][:password].blank? || params[:lab_user][:confirm_password].blank?
        redirect_to reset_pass_lab_user_path(@user,:reset_token=>params[:lab_user][:token]), :notice => "密码或者确认密码不能为空."
        return 
    else
      if params[:lab_user][:password] != params[:lab_user][:confirm_password]
        redirect_to reset_pass_lab_user_path(@user,:reset_token=>params[:lab_user][:token]), :notice => "密码和确认密码不一致."
        return
      end
    end

    @user.secret_key = Base64.encode64 params[:lab_user][:password]
    @user.password = Digest::MD5.hexdigest(params[:lab_user][:password])
    @user.save

    @edx_user = EdxUser.find_by_email(@user.email)
    encode_str = Base64.encode64 PBKDF256.dk(params[:lab_user][:password],"uFocFWnOvIKN",10000,32)
    new_pass = "pbkdf2_sha256$10000$uFocFWnOvIKN$"+encode_str
    @edx_user.password = new_pass.chomp
    @edx_user.save

    redirect_to login_lab_users_path, notice: '密码修改完成，请用新密码登录.'
  end

  def forgot_pass
    render :layout => "home"
  end

  def pass
    @lab_user = LabUser.find(params[:id])
    @lab_user.status = 1
    @lab_user.save

    redirect_to lab_users_path
  end

  def home
    @articles = LabNotice.where(:notice_type=>1,:published=>1).paginate(:page => params[:page], :per_page => 5).order("published_at DESC")
    @projects = LabEvalProject.where(:status=>1).paginate(:page => params[:page], :per_page => 5).order("created_at DESC")
    render :layout => "home"
  end

  def login
    render :layout => "home"
  end

  # GET /lab_users/1
  # GET /lab_users/1.json
  def show
    @lab_user = LabUser.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lab_user }
    end
  end

  # GET /lab_users/new
  # GET /lab_users/new.json
  def new
    @lab_user = LabUser.new
    render :layout => "blank"
  end

  # GET /lab_users/1/edit
  def edit
    @lab_user = LabUser.find(params[:id])
    render :layout => "blank"
  end

  # POST /lab_users
  # POST /lab_users.json
  def create
    @lab_user = LabUser.new(params[:lab_user])

    @lab_user.secret_key = Base64.encode64 params[:lab_user][:password]

    @lab_user.password = Digest::MD5.hexdigest(params[:lab_user][:password])

    @check_user = EdxUser.find_by_email(params[:lab_user][:email])

    LabUser.transaction do
      respond_to do |format|
        if @lab_user.save && @check_user.blank?
          edx = EdxUser.new
          edx.username = @lab_user.name
          edx.email = @lab_user.email
          encode_str = Base64.encode64 PBKDF256.dk(params[:lab_user][:password],"uFocFWnOvIKN",10000,32)
          new_pass = "pbkdf2_sha256$10000$uFocFWnOvIKN$"+encode_str
          edx.password = new_pass.chomp
          edx.is_staff = 0
          edx.is_active = 1
          edx.first_name = ''
          edx.last_name = ''
          edx.is_superuser = 0
          edx.last_login = Time.now.strftime('%Y-%m-%d %H:%M:%S')
          edx.date_joined = Time.now.strftime('%Y-%m-%d %H:%M:%S')
          edx.save

          profile = EdxProfile.new
          profile.user_id = edx.id
          profile.name = @lab_user.name
          profile.language = ''
          profile.location = ''
          profile.meta = ''
          profile.mailing_address = ''
          profile.goals = ''
          profile.country = ''
          profile.courseware = "course.xml"
          profile.gender = 'm'
          profile.year_of_birth = 2010
          profile.level_of_education = 'b'
          profile.allow_certificate = 1
          profile.save

          prefer = EdxApiPreference.new
          prefer.user_id = edx.id
          prefer.key = "pref-lang"
          prefer.value = 'zh-cn'
          prefer.save


          user = User.new
          user.external_id = edx.id
          user.default_sort_key = "date"
          user.external_id = 26
          user.username = @lab_user.name
          user.email = @lab_user.email
          user.save

          format.html { redirect_to login_lab_users_path, notice: '用户注册完成，请等待管理员审核通过.' }
          format.json { render json: @lab_user, status: :created, location: @lab_user }
        else
          if !@check_user.blank?
            @lab_user.errors[:email].push "Email已经存在."
          end
          format.html { render action: "new" ,:layout => "blank"}
          format.json { render json: @lab_user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /lab_users/1
  # PUT /lab_users/1.json
  def update
    @lab_user = LabUser.find(params[:id])

    respond_to do |format|
      if @lab_user.update_attributes(params[:lab_user])
        format.html { redirect_to @lab_user, notice: 'Lab user was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @lab_user.errors, status: :unprocessable_entity }
      end
    end
  end


  def login_in
    if params[:lab_user][:account].blank?
      redirect_to login_lab_users_path, :notice => "用户名不能为空."
      return
    end
    if params[:lab_user][:password].blank?
      redirect_to login_lab_users_path, :notice => "密码不能为空."
      return
    end
    @user = LabUser.find_by_account(params[:lab_user][:account])

    if @user.blank?
      redirect_to login_lab_users_path, :notice => "用户不存在."
      return
    end

    if @user.status != 1
      redirect_to login_lab_users_path, :notice => "用户注册还没有审核通过."
      return
    end

    if @user.password == Digest::MD5.hexdigest(params[:lab_user][:password])
      secret_key = "_m_lab" + params[:lab_user][:password]
      cookies[:lab_member_id] = @user.id
      cookies[:lab_login] = Digest::MD5.hexdigest(secret_key)

      # @logger ||= Logger.new("log/login.log")

      # redirect_to "http://101.226.163.149/login_auto?username=test&password=123456&forword=http://101.226.163.150"+Rails.application.routes.url_helpers.send(@user.lab_role.path)
      


      # dict = {}
      # dict["_session_expiry"] = 0
      # dict["_auth_user_backend"] = "ratelimitbackend.backends.RateLimitModelBackend"
      # dict["_auth_user_id"] = 26
      # dict["django_language"] = 'zh-cn'

      # s_data = ActiveSupport::JSON.decode(ActiveSupport::JSON.encode(dict))
      # RubyPython.start
      # pickle = RubyPython.import("pickle")
      # n_data = pickle.dumps(dict,pickle.HIGHEST_PROTOCOL)

      # session = EdxSession.new
      # session.session_key = dict.hash
      # new_data = dict.hash.to_s+":"+n_data.to_s
      # session.session_data = Base64.encode64 new_data
      # session.expire_date = (Time.now + 30.day).strftime('%Y-%m-%d %H:%M:%S')
      # session.save

      # cookies[:sessionid] = dict.hash

      # pp "-----a--------"
      # pp @user
      # pp @user.lab_role
      # pp @user.lab_role.path
      redirect_to Rails.application.routes.url_helpers.send(@user.lab_role.path)
    else
      redirect_to login_lab_users_path, :notice => "用户名或者密码不正确."
      return
    end

  end


  def logout
    cookies.delete :lab_member_id
    cookies.delete :lab_login
    redirect_to login_lab_users_path
  end

  # DELETE /lab_users/1
  # DELETE /lab_users/1.json
  def destroy
    @lab_user = LabUser.find(params[:id])
    @lab_user.destroy

    respond_to do |format|
      format.html { redirect_to lab_users_url }
      format.json { head :no_content }
    end
  end
end
