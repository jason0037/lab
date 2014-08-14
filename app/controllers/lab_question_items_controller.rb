require 'pp'
class LabQuestionItemsController < ApplicationController
  # GET /lab_question_items
  # GET /lab_question_items.json
  layout "blank"#,:except => [:show]
  def search
    @action='/lab_question_items/0/search'
    @key=params[:key]

    @lab_question_items =  LabQuestionItem.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")
    if @key
      @lab_question_items =@lab_question_items.where("name like '%#{@key}%'")
    end
    render 'lab_question_items/index'
  end

  def index
    @action='/lab_question_items/0/search'
    @lab_question_items = LabQuestionItem.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lab_question_items }
    end
  end

  # GET /lab_question_items/1
  # GET /lab_question_items/1.json
  def show
    @lab_question_item = LabQuestionItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lab_question_item }
    end
  end

  # GET /lab_question_items/new
  # GET /lab_question_items/new.json
  def new
    @lab_question_item = LabQuestionItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lab_question_item }
    end
  end

  # GET /lab_question_items/1/edit
  def edit
    @lab_question_item = LabQuestionItem.find(params[:id])
  end

  # POST /lab_question_items
  # POST /lab_question_items.json
  def create
    @lab_question_item = LabQuestionItem.new(params[:lab_question_item])

    respond_to do |format|
      if @lab_question_item.save
        format.html { redirect_to @lab_question_item, notice: 'Lab question item was successfully created.' }
        format.json { render json: @lab_question_item, status: :created, location: @lab_question_item }
      else
        format.html { render action: "new" }
        format.json { render json: @lab_question_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lab_question_items/1
  # PUT /lab_question_items/1.json
  def update
    @lab_question_item = LabQuestionItem.find(params[:id])

    respond_to do |format|
      if @lab_question_item.update_attributes(params[:lab_question_item])
        format.html { redirect_to @lab_question_item, notice: 'Lab question item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @lab_question_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lab_question_items/1
  # DELETE /lab_question_items/1.json
  def destroy
    @lab_question_item = LabQuestionItem.find(params[:id])
    @lab_question_item.destroy

    respond_to do |format|
      format.html { redirect_to lab_question_items_url }
      format.json { head :no_content }
    end
  end
end
