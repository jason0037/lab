require 'pp'
class LabDevicesController < ApplicationController
  before_filter :authorize_user!,:except => [:app_query,:app_save,:create,:update]
  # GET /lab_devices
  # GET /lab_devices.json
  layout "blank"#,:except => [:show]
  def app_query
    bn = params[:bn]
    device = LabDevice.find_by_bn(bn)

    if device.blank?
      result = 200 # "设备不存在."
      device = LabDevice.where("bn like '%#{bn[0,8]}%'").first
      if device.blank?
        render :text=>{ :code => result }.to_json
      else

        render :text => { :code => result,:device =>
            { :id=>device.id,:name=>device.name, :version=>device.version,:brand=>device.brand,:assets_no=>device.assets_no,:device_type=>device.device_type ,:status=>device.status,:cost=>device.cost,:bn=>device.bn,:photo=>device.photo,:supplier=>device.supplier} }.to_json
      end
    else
      result=0
      render :text => { :code => result,:device =>
          { :id=>device.id,:name=>device.name, :version=>device.version,:brand=>device.brand,:assets_no=>device.assets_no,:device_type=>device.device_type ,:status=>device.status,:cost=>device.cost,:bn=>device.bn,:photo=>device.photo,:supplier=>device.supplier} }.to_json
    end
  rescue
    result = 9999
    return render :text=>{ :code => result }.to_json
  end

#post
  def app_save
#    save='{"id":2,"name":"\u8def\u7531\u5668 lab_test","version":"","brand":"\u864e\u7b26","device_type":"\u8def\u7531\u5668","cost":"3439.0","bn":"3039393993","photo":"/teachResources/devices/20140813235914.jpg","supplier":"\u9f99\u8f6f"}'
    save = params[:submit_data]
    save =JSON.parse(save)
   # return render :text=>save
    #return save(id)
    result = 9999
    if  save['id']
      @device = LabDevice.find(save['id'])
      @device.name = save['name']
      @device.version = save['version']
      @device.brand = save['brand']
      @device.device_type = save['brand']
      @device.cost = save['cost']
      @device.bn = save['bn']
      @device.photo = save['photo']
      @device.supplier = save ['supplier']
      @device.status = save['status']
    #  if @lab_user.update_attributes(params[:lab_user])
      #  @app_test = AppTest.new(params[:app_test])
      if @device.save
        result =0
        return render :text=>{ :code => result }.to_json
      else
        return render :text=>{ :code => result }.to_json
      end
    end
  rescue
   return render :text=>{ :code => result }.to_json
  end

  def search
    @action='/lab_devices/0/search'
    @key=params[:key]

    @lab_devices =  LabDevice.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")
    if @key
      @lab_devices =@lab_devices.where("name like '%#{@key}%'")
    end
    render 'lab_devices/index'
  end

  def index
    @action='/lab_devices/0/search'
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
  #  return render :text => params[:lab_device]

    @lab_device = LabDevice.new(params[:lab_device])

    if params[:lab_device][:from]=='app'
      if @lab_device.save
        result = 0
      else
       result = 200
      end
      return render :text => { :code => result}.to_json
    end
#  rescue  Exception => e
 #   return render :text=>{ :code => 9999,:err=>e.message }.to_json

    respond_to do |format|
        if @lab_device.save
            format.html { redirect_to @lab_device, notice: 'Lab device was successfully created.' }
            format.json { render json: @lab_device, status: :created, location: @lab_device }
        else
            format.html { render action: "new" }
            format.json { render json: @lab_device.errors, status: :unprocessable_entity }
      end
  end

  # PUT /lab_devices/1
  # PUT /lab_devices/1.json
  def update
    @lab_device = LabDevice.find(params[:id])
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

      respond_to do |format|
        if @lab_device.update_attributes(params[:lab_device])
          if params[:lab_device][:from]=='app'
            render render :text => { :code => 0}.to_json
          else
            format.html { redirect_to @lab_device, notice: 'Lab device was successfully updated.' }
            format.json { head :no_content }
          end
        else
          format.html { render action: "edit" }
          format.json { render json: @lab_device.errors, status: :unprocessable_entity }
        end
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
