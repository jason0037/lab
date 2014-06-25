# encoding: utf-8

class AppTestsController < ApplicationController

  layout "blank"

  # GET /lab_users
  # GET /lab_users.json
  def index
    @lab_users = LabUser.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")

  end

  def query
    if params[:s].blank?
      @query_text = ""
      @lab_users = LabUser.where(:role_id=>5).paginate(:page => params[:page], :per_page => 5).order("created_at DESC")
    else
      @query_text = params[:s][:name]
      @lab_users = LabUser.where("role_id = ? and name like ?",5,"%#{params[:s][:name]}%").paginate(:page => params[:page], :per_page => 5).order("created_at DESC")
    end

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
    return
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
  def register
   redirect_to "/lab_users/new"
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

  def login
    result = 9999

    @user = LabUser.find_by_account(params[:lab_user][:account])

    if @user.blank?
      result = 200 # "用户不存在."
      return render :text=>result
    end

    if @user.password != Digest::MD5.hexdigest(params[:lab_user][:password])
      result = 201 #"用户名或者密码不正确."
      return render :text=>result
    else
      result = 0
      score = 0
    end
    render :text => { :code => result,:userInfo => { :userId => @user.id,:name=>@user.name,:age=>@user.age,:sex=>@user.sex,:school=>@user.school,:score=>score} }
=begin
<code>0</code> <userInfo> <userId>0xxxxxxx</userId> <name>xxxxx</name> <age>16</age> <sex>男</sex> <school>上海开放大学</school> <score>84</score> </userInfo>
=end
  end

  def logout
#add to log
  end

  def destroy
    @app_test = AppTest.find(params[:id])
    @app_test.destroy
  end
end
