require 'pp'
class LabSuppliersController < ApplicationController
  # GET /lab_suppliers
  # GET /lab_suppliers.json

  layout "blank"#,:except => [:show]

  def search
    @action='/lab_suppliers/0/search'
    @key=params[:key]

    @lab_suppliers =  LabSupplier.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")
    if @key
      @lab_suppliers =@lab_suppliers.where("name like '%#{@key}%'")
    end
    render 'lab_suppliers/index'
  end

  def index
    @action='/lab_suppliers/0/search'
    @lab_suppliers = LabSupplier.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lab_suppliers }
    end
  end

  # GET /lab_suppliers/1
  # GET /lab_suppliers/1.json
  def show
    @lab_supplier = LabSupplier.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lab_supplier }
    end
  end

  # GET /lab_suppliers/new
  # GET /lab_suppliers/new.json
  def new
    @lab_supplier = LabSupplier.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lab_supplier }
    end
  end

  # GET /lab_suppliers/1/edit
  def edit
    @lab_supplier = LabSupplier.find(params[:id])
  end

  # POST /lab_suppliers
  # POST /lab_suppliers.json
  def create
    @lab_supplier = LabSupplier.new(params[:lab_supplier])

    respond_to do |format|
      if @lab_supplier.save
        format.html { redirect_to @lab_supplier, notice: 'Lab supplier was successfully created.' }
        format.json { render json: @lab_supplier, status: :created, location: @lab_supplier }
      else
        format.html { render action: "new" }
        format.json { render json: @lab_supplier.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lab_suppliers/1
  # PUT /lab_suppliers/1.json
  def update
    @lab_supplier = LabSupplier.find(params[:id])

    respond_to do |format|
      if @lab_supplier.update_attributes(params[:lab_supplier])
        format.html { redirect_to @lab_supplier, notice: 'Lab supplier was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @lab_supplier.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lab_suppliers/1
  # DELETE /lab_suppliers/1.json
  def destroy
    @lab_supplier = LabSupplier.find(params[:id])
    @lab_supplier.destroy

    respond_to do |format|
      format.html { redirect_to lab_suppliers_url }
      format.json { head :no_content }
    end
  end
end
