require 'pp'
class LabDevicesController < ApplicationController
  before_filter :authorize_user!,:except => [:app_query,:app_add,:app_edit]
  # GET /lab_devices
  # GET /lab_devices.json
  layout "blank"#,:except => [:show]
  def app_query
    @device = LabDevice.find_by_bn(params[:bn])

    if @device.blank?
      result = 200 # "设备不存在."
      return render :text=>{ :code => result }.to_json
    else
      result=0
      render :text => { :code => result,:device =>
          { :id=>@device.id,:name=>@device.name, :version=>@device.version,:brand=>@device.brand,:device_type=>@device.device_type ,:cost=>@device.cost,:bn=>@device.bn,:photo=>@device.photo,:supplier=>@device.supplier} }.to_json
    end
  rescue
    result = 9999
    return render :text=>{ :code => result }.to_json
  end

  def app_save
    result = 9999
    if params[:userId]
      @lab_user = LabUser.find(params[:userId])
      if @lab_user.update_attributes(params[:lab_user])
        result =0
        return render :text=>{ :code => result }.to_json
      else
        return render :text=>{ :code => result }.to_json
      end
    end
    if params[:app_test]
      @app_test = AppTest.new(params[:app_test])
      if @app_test.save
        result =0
        return render :text=>{ :code => result }.to_json
      else
        return render :text=>{ :code => result }.to_json
      end
    end
  rescue
    return render :text=>{ :code => result }.to_json
  end

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
    uploaded_io = params[:file]
    if !uploaded_io.blank?
      extension = uploaded_io.original_filename.split('.')
      filename = "#{Time.now.strftime('%Y%m%d%H%M%S')}.#{extension[-1]}"
      filepath = "#{PIC_PATH}/teachResources/devices/#{filename}"
      File.open(filepath, 'wb') do |file|
        file.write(uploaded_io.read)
      end
      params[:lab_device].merge!(:photo=>"/teachResources/devices/#{filename}")
    end
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
