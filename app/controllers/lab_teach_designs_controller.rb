class LabTeachDesignsController < ApplicationController
  # GET /lab_teach_designs
  # GET /lab_teach_designs.json
  layout "blank",:except => [:show]
  def index
    @lab_teach_designs = LabTeachDesign.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lab_teach_designs }
    end
  end

  # GET /lab_teach_designs/1
  # GET /lab_teach_designs/1.json
  def show
    @lab_teach_design = LabTeachDesign.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lab_teach_design }
    end
  end

  # GET /lab_teach_designs/new
  # GET /lab_teach_designs/new.json
  def new
    @lab_teach_design = LabTeachDesign.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lab_teach_design }
    end
  end

  # GET /lab_teach_designs/1/edit
  def edit
    @lab_teach_design = LabTeachDesign.find(params[:id])
  end

  # POST /lab_teach_designs
  # POST /lab_teach_designs.json
  def create
    params[:lab_teach_design].merge!(:applicant_id=>@user.id)
    params[:lab_teach_design].merge!(:status=>'0')
    @lab_teach_design = LabTeachDesign.new(params[:lab_teach_design])

    respond_to do |format|
      if @lab_teach_design.save
        format.html { redirect_to @lab_teach_design, notice: 'Lab teach design was successfully created.' }
        format.json { render json: @lab_teach_design, status: :created, location: @lab_teach_design }
      else
        format.html { render action: "new" }
        format.json { render json: @lab_teach_design.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lab_teach_designs/1
  # PUT /lab_teach_designs/1.json
  def update
    @lab_teach_design = LabTeachDesign.find(params[:id])

    respond_to do |format|
      if @lab_teach_design.update_attributes(params[:lab_teach_design])
        format.html { redirect_to @lab_teach_design, notice: 'Lab teach design was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @lab_teach_design.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lab_teach_designs/1
  # DELETE /lab_teach_designs/1.json
  def destroy
    @lab_teach_design = LabTeachDesign.find(params[:id])
    @lab_teach_design.destroy

    respond_to do |format|
      format.html { redirect_to lab_teach_designs_url }
      format.json { head :no_content }
    end
  end
end
