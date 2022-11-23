class TiradsController < ApplicationController
  before_action :set_tirad, only: [:show, :edit, :update, :destroy]

  # GET /tirads
  # GET /tirads.json
  def index
    @tirads = Tirad.where("fecha>=? and fecha<=?","2022-10-31 00:00:00","2022-12-31 23:59:59").order(:fecha,:turno,:employee_id).paginate(:page => params[:page], :per_page => 20)
     respond_to do |format|
      format.html
      format.csv { send_data @tirads.to_csv }
    
    end

  end


  def import
       Tirad.import(params[:file])
       redirect_to root_url, notice: "Tiradas importadas."
  end 


  # GET /tirads/1
  # GET /tirads/1.json
  def show
     @employees = Employee.all
  end

  # GET /tirads/new
  def new
    @tirad = Tirad.new
     @employees = Employee.all
  end

  # GET /tirads/1/edit
  def edit
     @employees = Employee.all
  end

  # POST /tirads
  # POST /tirads.json
  def create
    @tirad = Tirad.new(tirad_params)
 @employees = Employee.all
    respond_to do |format|
      if @tirad.save
        format.html { redirect_to @tirad, notice: 'Tirad was successfully created.' }
        format.json { render :show, status: :created, location: @tirad }
      else
        format.html { render :new }
        format.json { render json: @tirad.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tirads/1
  # PATCH/PUT /tirads/1.json
  def update
    
    respond_to do |format|
      if @tirad.update(tirad_params)
        format.html { redirect_to @tirad, notice: 'Tirad was successfully updated.' }
        format.json { render :show, status: :ok, location: @tirad }
      else
        format.html { render :edit }
        format.json { render json: @tirad.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tirads/1
  # DELETE /tirads/1.json
  def destroy
    @tirad.destroy
    respond_to do |format|
      format.html { redirect_to tirads_url, notice: 'Tirad was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tirad
      @tirad = Tirad.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tirad_params
      params.require(:tirad).permit(:employee_id, :turno, :fecha, :importe,:documento,:moneda,:isla,:autoriza)
    end
end
