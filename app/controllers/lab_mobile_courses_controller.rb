class LabMobileCoursesController < ApplicationController
  # GET /lab_mobile_courses
  # GET /lab_mobile_courses.json
  layout "blank",:except => [:show]
  def index
    @lab_mobile_courses = LabMobileCourse.all

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
