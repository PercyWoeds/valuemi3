class PuntosController < ApplicationController
  before_action :set_punto, only: [:show, :edit, :update, :destroy]

  # GET /puntos
  # GET /puntos.json
  def index
    @puntos = Punto.all
  end

  # GET /puntos/1
  # GET /puntos/1.json
  def show
  end

  # GET /puntos/new
  def new
    @punto = Punto.new
  end

  # GET /puntos/1/edit
  def edit
  end

  # POST /puntos
  # POST /puntos.json
  def create
    @punto = Punto.new(punto_params)

    respond_to do |format|
      if @punto.save
        format.html { redirect_to @punto, notice: 'Punto was successfully created.' }
        format.json { render :show, status: :created, location: @punto }
      else
        format.html { render :new }
        format.json { render json: @punto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /puntos/1
  # PATCH/PUT /puntos/1.json
  def update
    respond_to do |format|
      if @punto.update(punto_params)
        format.html { redirect_to @punto, notice: 'Punto was successfully updated.' }
        format.json { render :show, status: :ok, location: @punto }
      else
        format.html { render :edit }
        format.json { render json: @punto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /puntos/1
  # DELETE /puntos/1.json
  def destroy
    @punto.destroy
    respond_to do |format|
      format.html { redirect_to puntos_url, notice: 'Punto was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_punto
      @punto = Punto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def punto_params
      params.require(:punto).permit(:name)
    end
end
