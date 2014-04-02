class LabSeatsController < ApplicationController
  # GET /lab_seats
  # GET /lab_seats.json
  layout "blank",:except => [:show]
  def index
    @lab_seats = LabSeat.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lab_seats }
    end
  end

  # GET /lab_seats/1
  # GET /lab_seats/1.json
  def show
    @lab_seat = LabSeat.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lab_seat }
    end
  end

  # GET /lab_seats/new
  # GET /lab_seats/new.json
  def new
    @lab_seat = LabSeat.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lab_seat }
    end
  end

  # GET /lab_seats/1/edit
  def edit
    @lab_seat = LabSeat.find(params[:id])
  end

  # POST /lab_seats
  # POST /lab_seats.json
  def create
    @lab_seat = LabSeat.new(params[:lab_seat])

    respond_to do |format|
      if @lab_seat.save
        format.html { redirect_to @lab_seat, notice: 'Lab seat was successfully created.' }
        format.json { render json: @lab_seat, status: :created, location: @lab_seat }
      else
        format.html { render action: "new" }
        format.json { render json: @lab_seat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lab_seats/1
  # PUT /lab_seats/1.json
  def update
    @lab_seat = LabSeat.find(params[:id])

    respond_to do |format|
      if @lab_seat.update_attributes(params[:lab_seat])
        format.html { redirect_to @lab_seat, notice: 'Lab seat was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @lab_seat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lab_seats/1
  # DELETE /lab_seats/1.json
  def destroy
    @lab_seat = LabSeat.find(params[:id])
    @lab_seat.destroy

    respond_to do |format|
      format.html { redirect_to lab_seats_url }
      format.json { head :no_content }
    end
  end
end
