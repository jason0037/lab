class LabEvalProjectsController < ApplicationController
  # GET /lab_eval_projects
  # GET /lab_eval_projects.json
  def index
    @lab_eval_projects = LabEvalProject.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lab_eval_projects }
    end
  end

  # GET /lab_eval_projects/1
  # GET /lab_eval_projects/1.json
  def show
    @lab_eval_project = LabEvalProject.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lab_eval_project }
    end
  end

  # GET /lab_eval_projects/new
  # GET /lab_eval_projects/new.json
  def new
    @lab_eval_project = LabEvalProject.new

    render :layout => "blank"
  end

  # GET /lab_eval_projects/1/edit
  def edit
    @lab_eval_project = LabEvalProject.find(params[:id])
  end

  # POST /lab_eval_projects
  # POST /lab_eval_projects.json
  def create
    @lab_eval_project = LabEvalProject.new(params[:lab_eval_project])

    respond_to do |format|
      if @lab_eval_project.save
        format.html { redirect_to @lab_eval_project, notice: 'Lab eval project was successfully created.' }
        format.json { render json: @lab_eval_project, status: :created, location: @lab_eval_project }
      else
        format.html { render action: "new" }
        format.json { render json: @lab_eval_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lab_eval_projects/1
  # PUT /lab_eval_projects/1.json
  def update
    @lab_eval_project = LabEvalProject.find(params[:id])

    respond_to do |format|
      if @lab_eval_project.update_attributes(params[:lab_eval_project])
        format.html { redirect_to @lab_eval_project, notice: 'Lab eval project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @lab_eval_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lab_eval_projects/1
  # DELETE /lab_eval_projects/1.json
  def destroy
    @lab_eval_project = LabEvalProject.find(params[:id])
    @lab_eval_project.destroy

    respond_to do |format|
      format.html { redirect_to lab_eval_projects_url }
      format.json { head :no_content }
    end
  end
end
