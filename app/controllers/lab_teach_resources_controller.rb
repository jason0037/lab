class LabTeachResourcesController < ApplicationController
  # GET /lab_teach_resources
  # GET /lab_teach_resources.json
  layout "blank",:except => [:show]
  def index
    @lab_teach_resources = LabTeachResource.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lab_teach_resources }
    end
  end

  # GET /lab_teach_resources/1
  # GET /lab_teach_resources/1.json
  def show
    @lab_teach_resource = LabTeachResource.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lab_teach_resource }
    end
  end

  # GET /lab_teach_resources/new
  # GET /lab_teach_resources/new.json
  def new
    @lab_teach_resource = LabTeachResource.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lab_teach_resource }
    end
  end

  # GET /lab_teach_resources/1/edit
  def edit
    @lab_teach_resource = LabTeachResource.find(params[:id])
  end

  # POST /lab_teach_resources
  # POST /lab_teach_resources.json
  def create
    @lab_teach_resource = LabTeachResource.new(params[:lab_teach_resource])

    respond_to do |format|
      if @lab_teach_resource.save
        format.html { redirect_to @lab_teach_resource, notice: 'Lab teach resource was successfully created.' }
        format.json { render json: @lab_teach_resource, status: :created, location: @lab_teach_resource }
      else
        format.html { render action: "new" }
        format.json { render json: @lab_teach_resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lab_teach_resources/1
  # PUT /lab_teach_resources/1.json
  def update
    @lab_teach_resource = LabTeachResource.find(params[:id])

    respond_to do |format|
      if @lab_teach_resource.update_attributes(params[:lab_teach_resource])
        format.html { redirect_to @lab_teach_resource, notice: 'Lab teach resource was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @lab_teach_resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lab_teach_resources/1
  # DELETE /lab_teach_resources/1.json
  def destroy
    @lab_teach_resource = LabTeachResource.find(params[:id])
    @lab_teach_resource.destroy

    respond_to do |format|
      format.html { redirect_to lab_teach_resources_url }
      format.json { head :no_content }
    end
  end
end
