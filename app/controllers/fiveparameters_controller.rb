class FiveparametersController < ApplicationController
  before_action :set_fiveparameter, only: [:show, :edit, :update, :destroy]

  # GET /fiveparameters
  # GET /fiveparameters.json
  def index
    @fiveparameters = Fiveparameter.all
  end

  # GET /fiveparameters/1
  # GET /fiveparameters/1.json
  def show
  end

  # GET /fiveparameters/new
  def new
    @fiveparameter = Fiveparameter.new
  end

  # GET /fiveparameters/1/edit
  def edit
  end

  # POST /fiveparameters
  # POST /fiveparameters.json
  def create
    @fiveparameter = Fiveparameter.new(fiveparameter_params)

    respond_to do |format|
      if @fiveparameter.save
        format.html { redirect_to @fiveparameter, notice: 'Fiveparameter was successfully created.' }
        format.json { render :show, status: :created, location: @fiveparameter }
      else
        format.html { render :new }
        format.json { render json: @fiveparameter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fiveparameters/1
  # PATCH/PUT /fiveparameters/1.json
  def update
    respond_to do |format|
      if @fiveparameter.update(fiveparameter_params)
        format.html { redirect_to @fiveparameter, notice: 'Fiveparameter was successfully updated.' }
        format.json { render :show, status: :ok, location: @fiveparameter }
      else
        format.html { render :edit }
        format.json { render json: @fiveparameter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fiveparameters/1
  # DELETE /fiveparameters/1.json
  def destroy
    @fiveparameter.destroy
    respond_to do |format|
      format.html { redirect_to fiveparameters_url, notice: 'Fiveparameter was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fiveparameter
      @fiveparameter = Fiveparameter.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fiveparameter_params
      params.require(:fiveparameter).permit(:anio, :valor_uit, :hasta_5, :tasa1,:tasa2, :tasa3,:tasa4,:tasa5,:tasa6,:tasa7,:tasa8,:exceso_5, :y_hasta_20, :exceso_20, :y_hasta_35, :exceso_35, :y_hasta_45, :exceso_45)
    end
end
