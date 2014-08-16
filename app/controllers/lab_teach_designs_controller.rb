require 'pp'
class LabTeachDesignsController < ApplicationController
  # GET /lab_teach_designs
  # GET /lab_teach_designs.json
  layout "blank"#,:except => [:show]
  def search
    @action='/lab_teach_designs/0/search'
    @key=params[:key]

    @lab_teach_designs =  LabTeachDesign.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")
    if @key
      @lab_teach_designs =@lab_teach_designs.where("title like '%#{@key}%'")
    end
    render 'lab_teach_designs/index'
  end

  def index
    @action='/lab_teach_designs/0/search'
    @lab_teach_designs = LabTeachDesign.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lab_teach_designs }
    end
  end

  # GET /lab_teach_designs/1
  # GET /lab_teach_designs/1.json
  def show
    @lab_teach_design = LabTeachDesign.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lab_teach_design }
    end
  end

  # GET /lab_teach_designs/new
  # GET /lab_teach_designs/new.json
  def new
    @lab_teach_design = LabTeachDesign.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lab_teach_design }
    end
  end

  # GET /lab_teach_designs/1/edit
  def edit
    @lab_teach_design = LabTeachDesign.find(params[:id])
  end

  # POST /lab_teach_designs
  # POST /lab_teach_designs.json
  def create(options={:encoding=>"GB18030:UTF-8"})
    uploaded_io = params[:file]
    if !uploaded_io.blank?
      extension=uploaded_io.original_filename.split('.')
      filename= "#{Time.now.strftime('%Y%m%d%H%M%S')}.#{extension[-1]}"
      filepath = "#{PIC_PATH}/teachResources/teachDesigns/#{filename}"
      File.open(filepath, 'wb') do |file|
        file.write(uploaded_io.read)
      end
  #    File.open(Rails.root.join('public', 'upload','teachDesigns',filename), 'wb') do |file|
  #      file.write(uploaded_io.read)
  #    end
      params[:lab_teach_design].merge!(:file=>"/teachResources/teachDesigns/#{filename}")
    end

    params[:lab_teach_design].merge!(:author_id=>@user.id)
    params[:lab_teach_design].merge!(:status=>'0')

    @lab_teach_design = LabTeachDesign.new(params[:lab_teach_design])

    respond_to do |format|
      if @lab_teach_design.save
        format.html { redirect_to @lab_teach_design, notice: 'Lab teach design was successfully created.' }
        format.json { render json: @lab_teach_design, status: :created, location: @lab_teach_design }
      else
        format.html { render action: "new" }
        format.json { render json: @lab_teach_design.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lab_teach_designs/1
  # PUT /lab_teach_designs/1.json
  def update

    uploaded_io = params[:file]
    if !uploaded_io.blank?
      extension=uploaded_io.original_filename.split('.')
      filename= "#{Time.now.strftime('%Y%m%d%H%M%S')}.#{extension[-1]}"
      File.open(Rails.root.join('public', 'upload','teachDesign',filename), 'wb') do |file|
        file.write(uploaded_io.read)
      end
      params[:lab_teach_design].merge!(:file=>"/upload/teachDesign/#{filename}")
    end

    @lab_teach_design = LabTeachDesign.find(params[:id])

    respond_to do |format|
      if @lab_teach_design.update_attributes(params[:lab_teach_design])
        format.html { redirect_to @lab_teach_design, notice: 'Lab teach design was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @lab_teach_design.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lab_teach_designs/1
  # DELETE /lab_teach_designs/1.json
  def destroy
    @lab_teach_design = LabTeachDesign.find(params[:id])
    @lab_teach_design.destroy

    respond_to do |format|
      format.html { redirect_to lab_teach_designs_url }
      format.json { head :no_content }
    end
  end
end
