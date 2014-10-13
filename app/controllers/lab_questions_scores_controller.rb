require 'pp'
class LabQuestionsScoresController < ApplicationController
  # GET /lab_questions_scores
  # GET /lab_questions_scores.json
  layout "blank"#,:except => [:show]
  def search
    @action='/lab_questions_scores/0/search'
    @key=params[:key]

    @lab_questions_scores =  LabQuestionsScore.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")
    if @key
      @lab_questions_scores =@lab_questions_scores.where("name like '%#{@key}%'")
    end
    render 'lab_questions_scores/index'
  end

  def index
    @action='/lab_questions_scores/0/search'
    @lab_questions_scores = LabQuestionsScore.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lab_questions_scores }
    end
  end

  # GET /lab_questions_scores/1
  # GET /lab_questions_scores/1.json
  def show
    @lab_questions_score = LabQuestionsScore.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lab_questions_score }
    end
  end

  # GET /lab_questions_scores/new
  # GET /lab_questions_scores/new.json
  def new
    @lab_questions = LabQuestion
    @question_categories = Option.question_category

    @lab_questions_score = LabQuestionsScore.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lab_questions_score }
    end
  end

  # GET /lab_questions_scores/1/edit
  def edit
    @lab_questions = LabQuestion
    @question_categories = Option.question_category

    @lab_questions_score = LabQuestionsScore.find(params[:id])
  end

  # POST /lab_questions_scores
  # POST /lab_questions_scores.json
  def create
    return render :text=>params[:questions].to_s

    @lab_questions_score = LabQuestionsScore.new


    respond_to do |format|
      if @lab_questions_score.save
        format.html { redirect_to @lab_questions_score, notice: 'Lab question item was successfully created.' }
        format.json { render json: @lab_questions_score, status: :created, location: @lab_questions_score }
      else
        format.html { render action: "new" }
        format.json { render json: @lab_questions_score.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lab_questions_scores/1
  # PUT /lab_questions_scores/1.json
  def update
    @lab_questions_score = LabQuestionsScore.find(params[:id])

    respond_to do |format|
      if @lab_questions_score.update_attributes(params[:lab_questions_score])
        format.html { redirect_to @lab_questions_score, notice: 'Lab question item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @lab_questions_score.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lab_questions_scores/1
  # DELETE /lab_questions_scores/1.json
  def destroy
    @lab_questions_score = LabQuestionsScore.find(params[:id])
    @lab_questions_score.destroy

    respond_to do |format|
      format.html { redirect_to lab_questions_scores_url }
      format.json { head :no_content }
    end
  end
end
