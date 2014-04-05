require 'pp'
class LabReportsController < ApplicationController
  # GET /lab_reports
  # GET /lab_reports.json
  layout "blank",:except => [:show]
  def index
    @lab_reports = LabReport.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lab_reports }
    end
  end

  # GET /lab_reports/1
  # GET /lab_reports/1.json
  def show
    @lab_report = LabReport.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lab_report }
    end
  end

  # GET /lab_reports/new
  # GET /lab_reports/new.json
  def new
    @lab_report = LabReport.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lab_report }
    end
  end

  # GET /lab_reports/1/edit
  def edit
    @lab_report = LabReport.find(params[:id])
  end

  # POST /lab_reports
  # POST /lab_reports.json
  def create
    @lab_report = LabReport.new(params[:lab_report])

    respond_to do |format|
      if @lab_report.save
        format.html { redirect_to @lab_report, notice: 'Lab report was successfully created.' }
        format.json { render json: @lab_report, status: :created, location: @lab_report }
      else
        format.html { render action: "new" }
        format.json { render json: @lab_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lab_reports/1
  # PUT /lab_reports/1.json
  def update
    @lab_report = LabReport.find(params[:id])

    respond_to do |format|
      if @lab_report.update_attributes(params[:lab_report])
        format.html { redirect_to @lab_report, notice: 'Lab report was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @lab_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lab_reports/1
  # DELETE /lab_reports/1.json
  def destroy
    @lab_report = LabReport.find(params[:id])
    @lab_report.destroy

    respond_to do |format|
      format.html { redirect_to lab_reports_url }
      format.json { head :no_content }
    end
  end
end
