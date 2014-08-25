require 'pp'
class LabQuestionnairesController < ApplicationController
  # GET /lab_questionnaires
  # GET /lab_questionnaires.json
  layout "blank"#,:except => [:show]
  def search
    @action='/lab_questionnaires/0/search'
    @key=params[:key]

    @lab_questionnaires =  LabQuestionnaire.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")
    if @key
      @lab_questionnaires =@lab_questionnaires.where("title like '%#{@key}%'")
    end
    render 'lab_questionnaires/index'
  end

  def index
    @action='/lab_questionnaires/0/search'
    @lab_questionnaires = LabQuestionnaire.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lab_questionnaires }
    end
  end

  # GET /lab_questionnaires/1
  # GET /lab_questionnaires/1.json
  def show
    @lab_questionnaire = LabQuestionnaire.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lab_questionnaire }
    end
  end

  # GET /lab_questionnaires/1/status
  def status
    questionnaire= LabQuestionnaire.find(params[:id])
    if questionnaire.status==1
      questionnaire.status=-1
    elsif questionnaire.status==0
      questionnaire.status=1
    end
    questionnaire.save
    redirect_to lab_questionnaires_path
  end

  # GET /lab_questionnaires/new
  # GET /lab_questionnaires/new.json
  def new
    @lab_questionnaire = LabQuestionnaire.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lab_questionnaire }
    end
  end

  # GET /lab_questionnaires/1/edit
  def edit
    @lab_questionnaire = LabQuestionnaire.find(params[:id])
  end

  # POST /lab_questionnaires
  # POST /lab_questionnaires.json
  def create
    params[:lab_questionnaire].merge!(:status=>0)
    @lab_questionnaire = LabQuestionnaire.new(params[:lab_questionnaire])

    respond_to do |format|
      if @lab_questionnaire.save
        format.html { redirect_to @lab_questionnaire, notice: 'Lab question was successfully created.' }
        format.json { render json: @lab_questionnaire, status: :created, location: @lab_questionnaire }
      else
        format.html { render action: "new" }
        format.json { render json: @lab_questionnaire.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lab_questionnaires/1
  # PUT /lab_questionnaires/1.json
  def update
    @lab_questionnaire = LabQuestionnaire.find(params[:id])

    respond_to do |format|
      if @lab_questionnaire.update_attributes(params[:lab_questionnaire])
        format.html { redirect_to @lab_questionnaire, notice: 'Lab question was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @lab_questionnaire.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lab_questionnaires/1
  # DELETE /lab_questionnaires/1.json
  def destroy
    @lab_questionnaire = LabQuestionnaire.find(params[:id])
    @lab_questionnaire.destroy

    respond_to do |format|
      format.html { redirect_to lab_questionnaires_url }
      format.json { head :no_content }
    end
  end
end
