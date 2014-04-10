require 'pp'
class LabCourseStudentsController < ApplicationController
  # GET /lab_course_students
  # GET /lab_course_students.json
  layout "blank"#,:except => [:show]
  def index
    @lab_course_students = LabCourseStudent.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lab_course_students }
    end
  end

  # GET /lab_course_students/1
  # GET /lab_course_students/1.json
  def show
    @lab_course_student = LabCourseStudent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lab_course_student }
    end
  end

  # GET /lab_course_students/new
  # GET /lab_course_students/new.json
  def new
    @lab_course_student = LabCourseStudent.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lab_course_student }
    end
  end

  # GET /lab_course_students/1/edit
  def edit
    @lab_course_student = LabCourseStudent.find(params[:id])
  end

  # POST /lab_course_students
  # POST /lab_course_students.json
  def create
    @lab_course_student = LabCourseStudent.new(params[:lab_course_student])

    respond_to do |format|
      if @lab_course_student.save
        format.html { redirect_to @lab_course_student, notice: 'Lab course student was successfully created.' }
        format.json { render json: @lab_course_student, status: :created, location: @lab_course_student }
      else
        format.html { render action: "new" }
        format.json { render json: @lab_course_student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lab_course_students/1
  # PUT /lab_course_students/1.json
  def update
    @lab_course_student = LabCourseStudent.find(params[:id])

    respond_to do |format|
      if @lab_course_student.update_attributes(params[:lab_course_student])
        format.html { redirect_to @lab_course_student, notice: 'Lab course student was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @lab_course_student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lab_course_students/1
  # DELETE /lab_course_students/1.json
  def destroy
    @lab_course_student = LabCourseStudent.find(params[:id])
    @lab_course_student.destroy

    respond_to do |format|
      format.html { redirect_to lab_course_students_url }
      format.json { head :no_content }
    end
  end
end
