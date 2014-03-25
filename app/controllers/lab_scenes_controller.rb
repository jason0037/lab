class LabScenesController < ApplicationController
  # GET /lab_scenes
  # GET /lab_scenes.json
  def index
    @lab_scenes = LabScene.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lab_scenes }
    end
  end

  # GET /lab_scenes/1
  # GET /lab_scenes/1.json
  def show
    @lab_scene = LabScene.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lab_scene }
    end
  end

  # GET /lab_scenes/new
  # GET /lab_scenes/new.json
  def new
    @lab_scene = LabScene.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lab_scene }
    end
  end

  # GET /lab_scenes/1/edit
  def edit
    @lab_scene = LabScene.find(params[:id])
  end

  # POST /lab_scenes
  # POST /lab_scenes.json
  def create
    @lab_scene = LabScene.new(params[:lab_scene])

    respond_to do |format|
      if @lab_scene.save
        format.html { redirect_to @lab_scene, notice: 'Lab scene was successfully created.' }
        format.json { render json: @lab_scene, status: :created, location: @lab_scene }
      else
        format.html { render action: "new" }
        format.json { render json: @lab_scene.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lab_scenes/1
  # PUT /lab_scenes/1.json
  def update
    @lab_scene = LabScene.find(params[:id])

    respond_to do |format|
      if @lab_scene.update_attributes(params[:lab_scene])
        format.html { redirect_to @lab_scene, notice: 'Lab scene was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @lab_scene.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lab_scenes/1
  # DELETE /lab_scenes/1.json
  def destroy
    @lab_scene = LabScene.find(params[:id])
    @lab_scene.destroy

    respond_to do |format|
      format.html { redirect_to lab_scenes_url }
      format.json { head :no_content }
    end
  end
end
