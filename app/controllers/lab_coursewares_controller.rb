require 'pp'
class LabCoursewaresController < ApplicationController
  # GET /lab_coursewares
  # GET /lab_coursewares.json
  layout "blank"#,:except => [:show]
  def search
    @action='/lab_coursewares/0/search'
    @key=params[:key]

    @lab_coursewares = LabCourseware.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")
    if @key
      @lab_coursewares =@lab_coursewares.where("name like '%#{@key}%'")
    end
    render 'lab_coursewares/index'
  end

  def index
    @action='/lab_coursewares/0/search'
    @lab_coursewares = LabCourseware.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lab_coursewares }
    end
  end

  # GET /lab_coursewares/1
  # GET /lab_coursewares/1.json
  def show
    @lab_courseware = LabCourseware.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lab_courseware }
    end
  end

  # GET /lab_coursewares/new
  # GET /lab_coursewares/new.json
  def new
    @lab_courseware = LabCourseware.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lab_courseware }
    end
  end

  # GET /lab_coursewares/1/edit
  def edit
    @lab_courseware = LabCourseware.find(params[:id])
  end

  # POST /lab_coursewares
  # POST /lab_coursewares.json
  def create
    @lab_courseware = LabCourseware.new(params[:lab_courseware])

    respond_to do |format|
      if @lab_courseware.save
        format.html { redirect_to @lab_courseware, notice: 'Lab courseware was successfully created.' }
        format.json { render json:  @lab_courseware, status: :created, location: @lab_courseware }
      else
        format.html { render action: "new" }
        format.json { render json: @lab_courseware.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lab_coursewares/1
  # PUT /lab_coursewares/1.json
  def update
    @lab_courseware = LabCourseware.find(params[:id])

    respond_to do |format|
      if @lab_courseware.update_attributes(params[:lab_courseware])
        format.html { redirect_to  @lab_courseware, notice: 'Lab courseware was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @lab_courseware.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lab_coursewares/1
  # DELETE /lab_coursewares/1.json
  def destroy
    @lab_courseware = LabCourseware.find(params[:id])
    @lab_courseware.destroy

    respond_to do |format|
      format.html { redirect_to lab_coursewares_url }
      format.json { head :no_content }
    end
  end
end
