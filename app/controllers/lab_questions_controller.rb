require 'pp'
class LabQuestionsController < ApplicationController
  # GET /lab_questions
  # GET /lab_questions.json
  layout "blank"#,:except => [:show]
  def search
    @action='/lab_questions/0/search'
    @key=params[:key]
    @questionnaire = params[:lab_questionnaire_id]

    @lab_questions =  LabQuestion.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")
    @lab_questions = @lab_questions.where(:questionnaire_id=>@questionnaire)
    if @key
      @lab_questions =@lab_questions.where("desc like '%#{@key}%'")
    end
    render 'lab_questions/index'
  end

  def index
    @questionnaire_id = params[:lab_questionnaire_id]
    @action='/lab_questions/0/search'
    @questionnaire = params[:lab_questionnaire_id]

    @lab_questions =  LabQuestion.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")
    @lab_questions = @lab_questions.where(:questionnaire_id=>@questionnaire)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lab_questions }
    end
  end

  # GET /lab_questions/1
  # GET /lab_questions/1.json
  def show
    @lab_question = LabQuestion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lab_question }
    end
  end

  # GET /lab_questions/new
  # GET /lab_questions/new.json
  def new
    @lab_question = LabQuestion.new
    @questionnaire = params[:lab_questionnaire_id]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lab_question }
    end
  end

  # GET /lab_questions/1/edit
  def edit
    @lab_question = LabQuestion.find(params[:id])
  end

  # POST /lab_questions
  # POST /lab_questions.json
  def create
    params[:lab_question].merge!(:questionnaire_id=>params[:questionnaire_id])
    @lab_question = LabQuestion.new(params[:lab_question])


    respond_to do |format|
      if @lab_question.save
        format.html { redirect_to @lab_question, notice: 'Lab question was successfully created.' }
        format.json { render json: @lab_question, status: :created, location: @lab_question }
      else
        format.html { render action: "new" }
        format.json { render json: @lab_question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lab_questions/1
  # PUT /lab_questions/1.json
  def update
    @lab_question = LabQuestion.find(params[:id])

    respond_to do |format|
      if @lab_question.update_attributes(params[:lab_question])
        format.html { redirect_to @lab_question, notice: 'Lab question was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @lab_question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lab_questions/1
  # DELETE /lab_questions/1.json
  def destroy
    @lab_question = LabQuestion.find(params[:id])
    @lab_question.destroy

    respond_to do |format|
      format.html { redirect_to lab_questions_url }
      format.json { head :no_content }
    end
  end
end
