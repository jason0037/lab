require 'pp'
class LabPermissionsRolesController < ApplicationController
  # GET /lab_permissions_roles
  # GET /lab_permissions_roles.json
  layout "blank"#,:except => [:show]
  def search
    @action='/lab_permissions_roles/0/search'
    @key=params[:key]

    @lab_permissions_roles =  LabPermissionsRole.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")
    if @key
      @lab_permissions_roles =@lab_permissions_roles.where("name like '%#{@key}%'")
    end
    render 'lab_permissions_roles/index'
  end

  def index
    @action='/lab_permissions_roles/0/search'
    @lab_permissions_roles = LabPermissionsRole.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lab_permissions_roles }
    end
  end

  # GET /lab_permissions_roles/1
  # GET /lab_permissions_roles/1.json
  def show
    @lab_permissions_role = LabPermissionsRole.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lab_permissions_role }
    end
  end

  # GET /lab_permissions_roles/new
  # GET /lab_permissions_roles/new.json
  def new
    @lab_permissions_role = LabPermissionsRole.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lab_permissions_role }
    end
  end

  # GET /lab_permissions_roles/1/edit
  def edit
    @lab_permissions_role = LabPermissionsRole.find(params[:id])
  end

  # POST /lab_permissions_roles
  # POST /lab_permissions_roles.json
  def create
    @lab_permissions_role = LabPermissionsRole.new(params[:lab_permissions_role])

    respond_to do |format|
      if @lab_permissions_role.save
        format.html { redirect_to @lab_permissions_role, notice: 'Lab permissions role was successfully created.' }
        format.json { render json: @lab_permissions_role, status: :created, location: @lab_permissions_role }
      else
        format.html { render action: "new" }
        format.json { render json: @lab_permissions_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lab_permissions_roles/1
  # PUT /lab_permissions_roles/1.json
  def update
    @lab_permissions_role = LabPermissionsRole.find(params[:id])

    respond_to do |format|
      if @lab_permissions_role.update_attributes(params[:lab_permissions_role])
        format.html { redirect_to @lab_permissions_role, notice: 'Lab permissions role was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @lab_permissions_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lab_permissions_roles/1
  # DELETE /lab_permissions_roles/1.json
  def destroy
    @lab_permissions_role = LabPermissionsRole.find(params[:id])
    @lab_permissions_role.destroy

    respond_to do |format|
      format.html { redirect_to lab_permissions_roles_url }
      format.json { head :no_content }
    end
  end
end
