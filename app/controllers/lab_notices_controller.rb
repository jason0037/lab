require 'pp'
class LabNoticesController < ApplicationController
  before_filter :authorize_user!,:except => [:show]
  
  layout "blank"#,:except => [:show]
  # GET /lab_notices
  # GET /lab_notices.json
  def search
    @action='/lab_notices/0/search'
    @key=params[:key]

    @lab_notices =  LabNotice.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")
    if @key
      @lab_notices =@lab_notices.where("title like '%#{@key}%'")
    end
    render 'lab_notices/index'
  end

  def index
    @action='/lab_notices/0/search'
    @lab_notices = LabNotice.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lab_notices }
    end
  end

  # GET /lab_notices/1
  # GET /lab_notices/1.json
  def show
    @lab_notice = LabNotice.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lab_notice }
    end
  end

  # GET /lab_notices/new
  # GET /lab_notices/new.json
  def new
    @lab_notice = LabNotice.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lab_notice }
    end
  end

  # GET /lab_notices/1/edit
  def edit
    @lab_notice = LabNotice.find(params[:id])
  end

  # POST /lab_notices
  # POST /lab_notices.json
  def create
    @lab_notice = LabNotice.new(params[:lab_notice])

    respond_to do |format|
      if @lab_notice.save
        format.html { redirect_to @lab_notice, notice: 'Lab notice was successfully created.' }
        format.json { render json: @lab_notice, status: :created, location: @lab_notice }
      else
        format.html { render action: "new" }
        format.json { render json: @lab_notice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lab_notices/1
  # PUT /lab_notices/1.json
  def update
    @lab_notice = LabNotice.find(params[:id])

    respond_to do |format|
      if @lab_notice.update_attributes(params[:lab_notice])
        format.html { redirect_to @lab_notice, notice: 'Lab notice was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @lab_notice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lab_notices/1
  # DELETE /lab_notices/1.json
  def destroy
    @lab_notice = LabNotice.find(params[:id])
    @lab_notice.destroy

    respond_to do |format|
      format.html { redirect_to lab_notices_url }
      format.json { head :no_content }
    end
  end
end
