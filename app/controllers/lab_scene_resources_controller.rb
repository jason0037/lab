class LabSceneResourcesController < ApplicationController
  # GET /lab_scene_resources
  # GET /lab_scene_resources.json
  def index
    @lab_scene_resources = LabSceneResource.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lab_scene_resources }
    end
  end

  # GET /lab_scene_resources/1
  # GET /lab_scene_resources/1.json
  def show
    @lab_scene_resource = LabSceneResource.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lab_scene_resource }
    end
  end

  # GET /lab_scene_resources/new
  # GET /lab_scene_resources/new.json
  def new
    @lab_scene_resource = LabSceneResource.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lab_scene_resource }
    end
  end

  # GET /lab_scene_resources/1/edit
  def edit
    @lab_scene_resource = LabSceneResource.find(params[:id])
  end

  # POST /lab_scene_resources
  # POST /lab_scene_resources.json
  def create
    @lab_scene_resource = LabSceneResource.new(params[:lab_scene_resource])

    respond_to do |format|
      if @lab_scene_resource.save
        format.html { redirect_to @lab_scene_resource, notice: 'Lab scene resource was successfully created.' }
        format.json { render json: @lab_scene_resource, status: :created, location: @lab_scene_resource }
      else
        format.html { render action: "new" }
        format.json { render json: @lab_scene_resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lab_scene_resources/1
  # PUT /lab_scene_resources/1.json
  def update
    @lab_scene_resource = LabSceneResource.find(params[:id])

    respond_to do |format|
      if @lab_scene_resource.update_attributes(params[:lab_scene_resource])
        format.html { redirect_to @lab_scene_resource, notice: 'Lab scene resource was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @lab_scene_resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lab_scene_resources/1
  # DELETE /lab_scene_resources/1.json
  def destroy
    @lab_scene_resource = LabSceneResource.find(params[:id])
    @lab_scene_resource.destroy

    respond_to do |format|
      format.html { redirect_to lab_scene_resources_url }
      format.json { head :no_content }
    end
  end
end
