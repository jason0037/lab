require 'pp'
class LabMobileCoursesController < ApplicationController
  # GET /lab_mobile_courses
  # GET /lab_mobile_courses.json
  layout "blank"#,:except => [:show]
  def search
    @action='/lab_mobile_courses/0/search'
    @key=params[:key]

    @lab_mobile_courses =  LabMobileCourse.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")
    if @key
      @lab_mobile_courses =@lab_mobile_courses.where("title like '%#{@key}%'")
    end
    render 'lab_mobile_courses/index'
  end

  def index
    @action='/lab_mobile_courses/0/search'
    @lab_mobile_courses = LabMobileCourse.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lab_mobile_courses }
    end
  end

  # GET /lab_mobile_courses/1
  # GET /lab_mobile_courses/1.json
  def show
    @lab_mobile_course = LabMobileCourse.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lab_mobile_course }
    end
  end

  # GET /lab_mobile_courses/new
  # GET /lab_mobile_courses/new.json
  def new
    @lab_mobile_course = LabMobileCourse.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lab_mobile_course }
    end
  end

  # GET /lab_mobile_courses/1/edit
  def edit
    @lab_mobile_course = LabMobileCourse.find(params[:id])
  end

  # POST /lab_mobile_courses
  # POST /lab_mobile_courses.json
  def create
    path ='/teachResources/mobileCourses/'
    uploaded_io = params[:file]
    if !uploaded_io.blank?
      extension=uploaded_io.original_filename.split('.')
      filename= "#{Time.now.strftime('%Y%m%d%H%M%S')}.#{extension[-1]}"
      filepath = "#{PIC_PATH}#{path}#{filename}"
      File.open(filepath, 'wb') do |file|
        file.write(uploaded_io.read)
      end
      params[:lab_mobile_course].merge!(:file=>"#{path}#{filename}")
    end
    params[:lab_mobile_course].merge!(:author_id=>@user.id)
    params[:lab_mobile_course].merge!(:status=>'0')
    @lab_mobile_course = LabMobileCourse.new(params[:lab_mobile_course])

    respond_to do |format|
      if @lab_mobile_course.save
        format.html { redirect_to @lab_mobile_course, notice: 'Lab mobile course was successfully created.' }
        format.json { render json: @lab_mobile_course, status: :created, location: @lab_mobile_course }
      else
        format.html { render action: "new" }
        format.json { render json: @lab_mobile_course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lab_mobile_courses/1
  # PUT /lab_mobile_courses/1.json
  def update
    #=========================
    ##删除原文件
    #...................
    #====================
    path ='/teachResources/mobileCourses/'
    uploaded_io = params[:file]
    if !uploaded_io.blank?
      extension=uploaded_io.original_filename.split('.')
      filename= "#{Time.now.strftime('%Y%m%d%H%M%S')}.#{extension[-1]}"
      filepath = "#{PIC_PATH}#{path}#{filename}"
      File.open(filepath, 'wb') do |file|
        file.write(uploaded_io.read)
      end
      params[:lab_mobile_course].merge!(:file=>"#{path}#{filename}")
    end
    @lab_mobile_course = LabMobileCourse.find(params[:id])

    respond_to do |format|
      if @lab_mobile_course.update_attributes(params[:lab_mobile_course])
        format.html { redirect_to @lab_mobile_course, notice: 'Lab mobile course was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @lab_mobile_course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lab_mobile_courses/1
  # DELETE /lab_mobile_courses/1.json
  def destroy
    @lab_mobile_course = LabMobileCourse.find(params[:id])
    @lab_mobile_course.destroy

    respond_to do |format|
      format.html { redirect_to lab_mobile_courses_url }
      format.json { head :no_content }
    end
  end
end
