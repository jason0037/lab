require 'pp'
class LabPermissionsController < ApplicationController
  # GET /lab_permissions
  # GET /lab_permissions.json
  layout "blank"#,:except => [:show]
  def index
    @lab_permissions = LabPermission.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lab_permissions }
    end
  end

  # GET /lab_permissions/1
  # GET /lab_permissions/1.json
  def show
    @lab_permission = LabPermission.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lab_permission }
    end
  end

  # GET /lab_permissions/new
  # GET /lab_permissions/new.json
  def new
    @lab_permission = LabPermission.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lab_permission }
    end
  end

  # GET /lab_permissions/1/edit
  def edit
    @lab_permission = LabPermission.find(params[:id])
  end

  # POST /lab_permissions
  # POST /lab_permissions.json
  def create
    @lab_permission = LabPermission.new(params[:lab_permission])

    respond_to do |format|
      if @lab_permission.save
        format.html { redirect_to @lab_permission, notice: 'Lab permission was successfully created.' }
        format.json { render json: @lab_permission, status: :created, location: @lab_permission }
      else
        format.html { render action: "new" }
        format.json { render json: @lab_permission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lab_permissions/1
  # PUT /lab_permissions/1.json
  def update
    @lab_permission = LabPermission.find(params[:id])

    respond_to do |format|
      if @lab_permission.update_attributes(params[:lab_permission])
        format.html { redirect_to @lab_permission, notice: 'Lab permission was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @lab_permission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lab_permissions/1
  # DELETE /lab_permissions/1.json
  def destroy
    @lab_permission = LabPermission.find(params[:id])
    @lab_permission.destroy

    respond_to do |format|
      format.html { redirect_to lab_permissions_url }
      format.json { head :no_content }
    end
  end
end
