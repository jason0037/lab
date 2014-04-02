class LabRolesController < ApplicationController
  # GET /lab_roles
  # GET /lab_roles.json
  layout "blank",:except => [:show]
  def index
    @lab_roles = LabRole.all

    render :layout => "blank"
  end

  # GET /lab_roles/1
  # GET /lab_roles/1.json
  def show
    @lab_role = LabRole.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lab_role }
    end
  end

  # GET /lab_roles/new
  # GET /lab_roles/new.json
  def new
    @lab_role = LabRole.new

    render :layout => "blank"
  end

  # GET /lab_roles/1/edit
  def edit
    @lab_role = LabRole.find(params[:id])
  end

  # POST /lab_roles
  # POST /lab_roles.json
  def create
    @lab_role = LabRole.new(params[:lab_role])

    respond_to do |format|
      if @lab_role.save
        format.html { redirect_to @lab_role, notice: 'Lab role was successfully created.' }
        format.json { render json: @lab_role, status: :created, location: @lab_role }
      else
        format.html { render action: "new" }
        format.json { render json: @lab_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lab_roles/1
  # PUT /lab_roles/1.json
  def update
    @lab_role = LabRole.find(params[:id])

    respond_to do |format|
      if @lab_role.update_attributes(params[:lab_role])
        format.html { redirect_to @lab_role, notice: 'Lab role was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @lab_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lab_roles/1
  # DELETE /lab_roles/1.json
  def destroy
    @lab_role = LabRole.find(params[:id])
    @lab_role.destroy

    respond_to do |format|
      format.html { redirect_to lab_roles_url }
      format.json { head :no_content }
    end
  end
end
