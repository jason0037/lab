require 'pp'
class LabDeviceSupportsController < ApplicationController
  # GET /lab_device_supports
  # GET /lab_device_supports.json
  layout "blank"#,:except => [:show]
  def search
    @action='/lab_device_supports/0/search'
    @key=params[:key]

    @lab_device_supports =  LabDeviceSupport.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")
    if @key
      @lab_device_supports =@lab_device_supports.where("name like '%#{@key}%'")
    end
    render 'lab_device_supports/index'
  end

  def index
    @action='/lab_device_supports/0/search'
    @lab_device_supports = LabDeviceSupport.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lab_device_supports }
    end
  end

  # GET /lab_device_supports/1
  # GET /lab_device_supports/1.json
  def show
    @lab_device_support = LabDeviceSupport.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lab_device_support }
    end
  end

  # GET /lab_device_supports/new
  # GET /lab_device_supports/new.json
  def new
    @lab_device_support = LabDeviceSupport.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lab_device_support }
    end
  end

  # GET /lab_device_supports/1/edit
  def edit
    @lab_device_support = LabDeviceSupport.find(params[:id])
  end

  # POST /lab_device_supports
  # POST /lab_device_supports.json
  def create
    @lab_device_support = LabDeviceSupport.new(params[:lab_device_support])

    respond_to do |format|
      if @lab_device_support.save
        format.html { redirect_to @lab_device_support, notice: 'Lab device support was successfully created.' }
        format.json { render json: @lab_device_support, status: :created, location: @lab_device_support }
      else
        format.html { render action: "new" }
        format.json { render json: @lab_device_support.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lab_device_supports/1
  # PUT /lab_device_supports/1.json
  def update
    @lab_device_support = LabDeviceSupport.find(params[:id])

    respond_to do |format|
      if @lab_device_support.update_attributes(params[:lab_device_support])
        format.html { redirect_to @lab_device_support, notice: 'Lab device support was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @lab_device_support.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lab_device_supports/1
  # DELETE /lab_device_supports/1.json
  def destroy
    @lab_device_support = LabDeviceSupport.find(params[:id])
    @lab_device_support.destroy

    respond_to do |format|
      format.html { redirect_to lab_device_supports_url }
      format.json { head :no_content }
    end
  end
end
