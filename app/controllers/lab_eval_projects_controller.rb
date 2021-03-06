require 'pp'

class LabEvalProjectsController < ApplicationController
  # GET /lab_eval_projects
  # GET /lab_eval_projects.json

  layout "blank"#,:except => [:show]
  def apply
    @action='/lab_eval_projects/0/search'
    if @user.role_id==4 || @user.role_id==6 #实验室管理员或系统管理员
      @lab_eval_projects = LabEvalProject.where("status=1")
    else
      @lab_eval_projects = LabEvalProject.where(:applicant_id=>@user.id)
    end
    @lab_eval_projects = @lab_eval_projects.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lab_eval_projects }
    end
  end

  def search
    @action='/lab_eval_projects/0/search'
    @key=params[:key]

    if @user.role_id==4 || @user.role_id==6 #实验室管理员或系统管理员
      @lab_eval_projects = LabEvalProject.where("status>1") #审批通过的项目进入评测
    else
      @lab_eval_projects = LabEvalProject.where(:applicant_id=>@user.id)
    end
    if @key
      @lab_eval_projects =@lab_eval_projects.where("name like '%#{@key}%'")
    end
    @lab_eval_projects = @lab_eval_projects.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")
   render 'lab_eval_projects/index'
  end

  def index
    @action='/lab_eval_projects/0/search'
    @lab_eval_projects = LabEvalProject.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")

    if @user.role_id==4 || @user.role_id==6 #实验室管理员或系统管理员
      @lab_eval_projects = @lab_eval_projects.where("status>1") #审批通过的项目进入评测
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lab_eval_projects }
    end
  end

  # GET /lab_eval_projects/1
  # GET /lab_eval_projects/1.json
  def show
   @lab_eval_project = LabEvalProject.find(params[:id])
   @eval_means = Option.where(:key=>"eval_means")
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lab_eval_project }
    end
  end

  # GET /lab_eval_projects/new
  # GET /lab_eval_projects/new.json
  def new
    @eval_means = Option.where(:key=>"eval_means")
    @teach_tools = Option.where(:key=>"teach_tools")
    @questionnaires=LabQuestionnaire.where(:status=>1)
    @lab_eval_project = LabEvalProject.new

    render :layout => "blank"
  end

  # GET /lab_eval_projects/1/edit
  def edit
    @eval_means = Option.where(:key=>"eval_means")
    @teach_tools = Option.where(:key=>"teach_tools")
    @lab_eval_project = LabEvalProject.find(params[:id])
  end

  # POST /lab_eval_projects
  # POST /lab_eval_projects.json
  def create
    teach_tools = params[:lab_eval_project].delete(:teach_tools).to_s
    #return render :text=>teach_tools

    status=0 #草稿状态
    eval_means = params[:lab_eval_project].delete(:eval_means).to_s
    if params[:lab_eval_project][:category_id]='3' #参观登记，自动成为申请状态
      status=1
    end
    params[:lab_eval_project].merge!(:applicant_id=>@user.id,:eval_means=>eval_means,:teach_tools=>teach_tools,:status=>status)

    @lab_eval_project = LabEvalProject.new(params[:lab_eval_project])

    respond_to do |format|
      if @lab_eval_project.save
        format.html { redirect_to apply_lab_eval_projects_path, notice: 'Lab eval project was successfully created.' }
        format.json { render json: apply_lab_eval_projects_path, status: :created, location: apply_lab_eval_projects_path }
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

    teach_tools = params[:lab_eval_project].delete(:teach_tools).to_s
    eval_means = params[:lab_eval_project].delete(:eval_means).to_s
    params[:lab_eval_project].merge!(:eval_means=>eval_means,:teach_tools=>teach_tools)

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

  def submit_apply
    @lab_eval_project = LabEvalProject.find(params[:id])
    respond_to do |format|
      if @lab_eval_project.update_attributes(:status => '1')
        format.html { redirect_to @lab_eval_project, notice: 'Lab eval project was successfully approved.' }
        format.json { head :no_content }
      else
        format.html { render action: "apply" }
        format.json { render json: @lab_eval_project.errors, status: :unprocessable_entity }
      end
    end
  end

  def approve
    @lab_eval_project = LabEvalProject.find(params[:id])

    respond_to do |format|
      if @lab_eval_project.update_attributes(:status => '2')
        format.html { redirect_to @lab_eval_project, notice: 'Lab eval project was successfully approved.' }
        format.json { head :no_content }
      else
        format.html { render action: "apply" }
        format.json { render json: @lab_eval_project.errors, status: :unprocessable_entity }
      end
    end
  end

  def reject
    @lab_eval_project = LabEvalProject.find(params[:id])

    respond_to do |format|
      if @lab_eval_project.update_attributes(:status => '-1')
        format.html { redirect_to @lab_eval_project, notice: 'Lab eval project was successfully rejected.' }
        format.json { head :no_content }
      else
        format.html { render action: "apply" }
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
      format.html { redirect_to apply_lab_eval_projects_url }
      format.json { head :no_content }
    end
  end
end
