require 'pp'
class LabCoursesController < ApplicationController
  before_filter :authorize_user!,:except => [:status]
  # GET /lab_courses
  # GET /lab_courses.json
  layout "blank"#,:except => [:show]

  def status
    #app接口，由移动终端发起课程开始或结束
    status=params[:status]
    result = 9999
    @lab_course= LabCourse.order("id desc").first
    now_status = @lab_course.status
    if status  == "1"
      if  now_status == 1
        result=0
        @lab_course.status=2
        @lab_course.begin_time_real=Time.now
        @lab_course.save
        #课程开始
      else
        result=200
      end
    elsif status=="0"
      if  now_status == 2
        result=0
        @lab_course.status = 3
        @lab_course.end_time_real=Time.now
        @lab_course.save
        #课程结束
      else
        result=200
      end
    end
    render :text => { :code => result}.to_json
  rescue
    return render :text=>{ :code => result }.to_json
  end

  def search
    @action='/lab_courses/0/search'
    @key=params[:key]
    @lab_courses = LabCourse.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")
    if @user.role_id==4 || @user.role_id==6 #实验室管理员或系统管理员
      if @key
        @lab_courses =@lab_courses.where("name like '%#{@key}%'")
      end
    else
      @lab_courses = @lab_courses.where(:teacher_id=>@user.id)
      if @key
        @lab_courses =@lab_courses.where("name like '%#{@key}%'")
      end
    end


    @lab_courses = @lab_courses.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")
    render 'lab_courses/index'
  end

  def index
    @action='/lab_courses/0/search'
    @lab_courses = LabCourse.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")
    if @user.role_id==4 || @user.role_id==6 #实验室管理员或系统管理员
      @lab_courses =@lab_courses.all
    else
      @lab_courses = @lab_courses.where(:teacher_id=>@user.id)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lab_courses }
    end
  end

  # GET /lab_courses/1
  # GET /lab_courses/1.json
  def show
    @lab_course = LabCourse.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lab_course }
    end
  end

  def teach
    # pp "-----a----------s------"
    passwd = Base64.decode64 @user.secret_key
    secKey = @user.name + "-" + passwd
    key = Base64.encode64 secKey
    # pp "---------a--------"
    # pp key
    redirect_to "http://101.226.163.149:18010/login_cms_auto?key=#{key}&forword=homepage"
  end

  def learn
    # pp "-----a----------s------"
    passwd = Base64.decode64 @user.secret_key
    secKey = @user.name + "-" + passwd
    key = Base64.encode64 secKey
    # pp "---------a--------"
    # pp key
    redirect_to "http://101.226.163.149/login_auto?key=#{key}&forword=dashboard"
  end

  # GET /lab_courses/new
  # GET /lab_courses/new.json
  def new
    @lab_course = LabCourse.new
    @id = params[:lab_eval_project_id]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lab_course }
    end
  end

  # GET /lab_courses/1/edit
  def edit
    @lab_course = LabCourse.find(params[:id])
  end

  # POST /lab_courses
  # POST /lab_courses.json
  def create
    params[:lab_course].merge!(:project_id=>params[:project_id],:status=>0)

    @lab_course = LabCourse.new(params[:lab_course])

    respond_to do |format|
      if @lab_course.save
        format.html { redirect_to @lab_course, notice: 'Lab course was successfully created.' }
        format.json { render json: @lab_course, status: :created, location: @lab_course }
      else
        format.html { render action: "new" }
        format.json { render json: @lab_course.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /lab_courses/1/grand
  def grand
    @lab_course = LabCourse.find(params[:id])
  end

  # GET /lab_course/1/opinion
  def opinion
    @lab_course = LabCourse.find(params[:id])
  end

  # PUT /lab_courses/1
  # PUT /lab_courses/1.json
  def update
    @lab_course = LabCourse.find(params[:id])

    if params[:lab_course][:grand]
      grand = params[:lab_course].delete(:grand).to_s
      params[:lab_course].merge!(:grand=>grand)
    end
    respond_to do |format|
      if @lab_course.update_attributes(params[:lab_course])
        format.html { redirect_to @lab_course, notice: 'Lab course was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @lab_course.errors, status: :unprocessable_entity }
      end
    end
  end

  def ready
    @lab_course = LabCourse.find(params[:id])
    @lab_course.status=1
    @lab_course.save
    redirect_to lab_courses_path
  end

  # DELETE /lab_courses/1
  # DELETE /lab_courses/1.json
  def destroy
    @lab_course = LabCourse.find(params[:id])
    @lab_course.destroy

    respond_to do |format|
      format.html { redirect_to lab_courses_url }
      format.json { head :no_content }
    end
  end
end
