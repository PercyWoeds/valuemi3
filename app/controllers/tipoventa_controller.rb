class TipoventaController < ApplicationController
  before_action :set_tipoventum, only: [:show, :edit, :update, :destroy]

  # GET /tipoventa
  # GET /tipoventa.json
  def index
    @tipoventa = Tipoventum.all
  end

  # GET /tipoventa/1
  # GET /tipoventa/1.json
  def show
  end

  # GET /tipoventa/new
  def new
    @tipoventum = Tipoventum.new
  end

  # GET /tipoventa/1/edit
  def edit
  end

  # POST /tipoventa
  # POST /tipoventa.json
  def create
    @tipoventum = Tipoventum.new(tipoventum_params)

    respond_to do |format|
      if @tipoventum.save
        format.html { redirect_to @tipoventum, notice: 'Tipoventum was successfully created.' }
        format.json { render :show, status: :created, location: @tipoventum }
      else
        format.html { render :new }
        format.json { render json: @tipoventum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tipoventa/1
  # PATCH/PUT /tipoventa/1.json
  def update
    respond_to do |format|
      if @tipoventum.update(tipoventum_params)
        format.html { redirect_to @tipoventum, notice: 'Tipoventum was successfully updated.' }
        format.json { render :show, status: :ok, location: @tipoventum }
      else
        format.html { render :edit }
        format.json { render json: @tipoventum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tipoventa/1
  # DELETE /tipoventa/1.json
  def destroy
    @tipoventum.destroy
    respond_to do |format|
      format.html { redirect_to tipoventa_url, notice: 'Tipoventum was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tipoventum
      @tipoventum = Tipoventum.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tipoventum_params
      params.require(:tipoventum).permit(:code, :nombre)
    end
end
