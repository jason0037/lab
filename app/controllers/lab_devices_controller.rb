require 'pp'
class LabDevicesController < ApplicationController
  # GET /lab_devices
  # GET /lab_devices.json
  layout "blank",:except => [:show]
  def index
    @lab_devices = LabDevice.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lab_devices }
    end
  end

  # GET /lab_devices/1
  # GET /lab_devices/1.json
  def show
    @lab_device = LabDevice.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lab_device }
    end
  end

  # GET /lab_devices/new
  # GET /lab_devices/new.json
  def new
    @lab_device = LabDevice.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lab_device }
    end
  end

  # GET /lab_devices/1/edit
  def edit
    @lab_device = LabDevice.find(params[:id])
  end

  # POST /lab_devices
  # POST /lab_devices.json
  def create
    @lab_device = LabDevice.new(params[:lab_device])

    respond_to do |format|
      if @lab_device.save
        format.html { redirect_to @lab_device, notice: 'Lab device was successfully created.' }
        format.json { render json: @lab_device, status: :created, location: @lab_device }
      else
        format.html { render action: "new" }
        format.json { render json: @lab_device.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lab_devices/1
  # PUT /lab_devices/1.json
  def update
    @lab_device = LabDevice.find(params[:id])

    respond_to do |format|
      if @lab_device.update_attributes(params[:lab_device])
        format.html { redirect_to @lab_device, notice: 'Lab device was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @lab_device.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lab_devices/1
  # DELETE /lab_devices/1.json
  def destroy
    @lab_device = LabDevice.find(params[:id])
    @lab_device.destroy

    respond_to do |format|
      format.html { redirect_to lab_devices_url }
      format.json { head :no_content }
    end
  end
end
