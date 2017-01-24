class NumerasController < ApplicationController
  before_action :set_numera, only: [:show, :edit, :update, :destroy]

  # GET /numeras
  # GET /numeras.json
  def index
    @numeras = Numera.all
  end

  # GET /numeras/1
  # GET /numeras/1.json
  def show
  end

  # GET /numeras/new
  def new
    @numera = Numera.new
  end

  # GET /numeras/1/edit
  def edit
  end

  # POST /numeras
  # POST /numeras.json
  def create
    @numera = Numera.new(numera_params)

    respond_to do |format|
      if @numera.save
        format.html { redirect_to @numera, notice: 'Numera was successfully created.' }
        format.json { render :show, status: :created, location: @numera }
      else
        format.html { render :new }
        format.json { render json: @numera.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /numeras/1
  # PATCH/PUT /numeras/1.json
  def update
    respond_to do |format|
      if @numera.update(numera_params)
        format.html { redirect_to @numera, notice: 'Numera was successfully updated.' }
        format.json { render :show, status: :ok, location: @numera }
      else
        format.html { render :edit }
        format.json { render json: @numera.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /numeras/1
  # DELETE /numeras/1.json
  def destroy
    @numera.destroy
    respond_to do |format|
      format.html { redirect_to numeras_url, notice: 'Numera was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_numera
      @numera = Numera.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def numera_params
      params.require(:numera).permit(:subdiario, :compro)
    end
end
