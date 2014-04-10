require 'pp'
class LabEquipmentsController < ApplicationController
  # GET /lab_equipments
  # GET /lab_equipments.json
  layout "blank"#,:except => [:show]
  def index
    @lab_equipments = LabEquipment.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lab_equipments }
    end
  end

  # GET /lab_equipments/1
  # GET /lab_equipments/1.json
  def show
    @lab_equipment = LabEquipment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lab_equipment }
    end
  end

  # GET /lab_equipments/new
  # GET /lab_equipments/new.json
  def new
    @lab_equipment = LabEquipment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lab_equipment }
    end
  end

  # GET /lab_equipments/1/edit
  def edit
    @lab_equipment = LabEquipment.find(params[:id])
  end

  # POST /lab_equipments
  # POST /lab_equipments.json
  def create
    @lab_equipment = LabEquipment.new(params[:lab_equipment])

    respond_to do |format|
      if @lab_equipment.save
        format.html { redirect_to @lab_equipment, notice: 'Lab equipment was successfully created.' }
        format.json { render json: @lab_equipment, status: :created, location: @lab_equipment }
      else
        format.html { render action: "new" }
        format.json { render json: @lab_equipment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lab_equipments/1
  # PUT /lab_equipments/1.json
  def update
    @lab_equipment = LabEquipment.find(params[:id])

    respond_to do |format|
      if @lab_equipment.update_attributes(params[:lab_equipment])
        format.html { redirect_to @lab_equipment, notice: 'Lab equipment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @lab_equipment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lab_equipments/1
  # DELETE /lab_equipments/1.json
  def destroy
    @lab_equipment = LabEquipment.find(params[:id])
    @lab_equipment.destroy

    respond_to do |format|
      format.html { redirect_to lab_equipments_url }
      format.json { head :no_content }
    end
  end
end
