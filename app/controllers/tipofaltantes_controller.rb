class TipofaltantesController < ApplicationController
  before_action :set_tipofaltante, only: [:show, :edit, :update, :destroy]

  # GET /tipofaltantes
  # GET /tipofaltantes.json
  def index
    @tipofaltantes = Tipofaltante.all
  end

  # GET /tipofaltantes/1
  # GET /tipofaltantes/1.json
  def show
  end

  # GET /tipofaltantes/new
  def new
    @tipofaltante = Tipofaltante.new
  end

  # GET /tipofaltantes/1/edit
  def edit
  end

  # POST /tipofaltantes
  # POST /tipofaltantes.json
  def create
    @tipofaltante = Tipofaltante.new(tipofaltante_params)

    respond_to do |format|
      if @tipofaltante.save
        format.html { redirect_to @tipofaltante, notice: 'Tipofaltante was successfully created.' }
        format.json { render :show, status: :created, location: @tipofaltante }
      else
        format.html { render :new }
        format.json { render json: @tipofaltante.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tipofaltantes/1
  # PATCH/PUT /tipofaltantes/1.json
  def update
    respond_to do |format|
      if @tipofaltante.update(tipofaltante_params)
        format.html { redirect_to @tipofaltante, notice: 'Tipofaltante was successfully updated.' }
        format.json { render :show, status: :ok, location: @tipofaltante }
      else
        format.html { render :edit }
        format.json { render json: @tipofaltante.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tipofaltantes/1
  # DELETE /tipofaltantes/1.json
  def destroy
    @tipofaltante.destroy
    respond_to do |format|
      format.html { redirect_to tipofaltantes_url, notice: 'Tipofaltante was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tipofaltante
      @tipofaltante = Tipofaltante.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tipofaltante_params
      params.require(:tipofaltante).permit(:code, :descrip)
    end
end
