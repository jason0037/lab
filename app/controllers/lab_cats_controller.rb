require 'pp'
class LabCatsController < ApplicationController
  # GET /lab_cats
  # GET /lab_cats.json
  layout "blank"#,:except => [:show]
  def index
    @lab_cats = LabCat.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lab_cats }
    end
  end

  # GET /lab_cats/1
  # GET /lab_cats/1.json
  def show
    @lab_cat = LabCat.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lab_cat }
    end
  end

  # GET /lab_cats/new
  # GET /lab_cats/new.json
  def new
    @lab_cat = LabCat.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lab_cat }
    end
  end

  # GET /lab_cats/1/edit
  def edit
    @lab_cat = LabCat.find(params[:id])
  end

  # POST /lab_cats
  # POST /lab_cats.json
  def create
    @lab_cat = LabCat.new(params[:lab_cat])

    respond_to do |format|
      if @lab_cat.save
        format.html { redirect_to @lab_cat, notice: 'Lab cat was successfully created.' }
        format.json { render json: @lab_cat, status: :created, location: @lab_cat }
      else
        format.html { render action: "new" }
        format.json { render json: @lab_cat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lab_cats/1
  # PUT /lab_cats/1.json
  def update
    @lab_cat = LabCat.find(params[:id])

    respond_to do |format|
      if @lab_cat.update_attributes(params[:lab_cat])
        format.html { redirect_to @lab_cat, notice: 'Lab cat was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @lab_cat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lab_cats/1
  # DELETE /lab_cats/1.json
  def destroy
    @lab_cat = LabCat.find(params[:id])
    @lab_cat.destroy

    respond_to do |format|
      format.html { redirect_to lab_cats_url }
      format.json { head :no_content }
    end
  end
end
