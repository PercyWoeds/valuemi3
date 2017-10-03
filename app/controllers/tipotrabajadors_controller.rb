class TipotrabajadorsController < ApplicationController
  before_action :set_tipotrabajador, only: [:show, :edit, :update, :destroy]

  # GET /tipotrabajadors
  # GET /tipotrabajadors.json
  def index
    @tipotrabajadors = Tipotrabajador.all
  end

  # GET /tipotrabajadors/1
  # GET /tipotrabajadors/1.json
  def show
  end

  # GET /tipotrabajadors/new
  def new
    @tipotrabajador = Tipotrabajador.new
  end

  # GET /tipotrabajadors/1/edit
  def edit
  end

  # POST /tipotrabajadors
  # POST /tipotrabajadors.json
  def create
    @tipotrabajador = Tipotrabajador.new(tipotrabajador_params)

    respond_to do |format|
      if @tipotrabajador.save
        format.html { redirect_to @tipotrabajador, notice: 'Tipotrabajador was successfully created.' }
        format.json { render :show, status: :created, location: @tipotrabajador }
      else
        format.html { render :new }
        format.json { render json: @tipotrabajador.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tipotrabajadors/1
  # PATCH/PUT /tipotrabajadors/1.json
  def update
    respond_to do |format|
      if @tipotrabajador.update(tipotrabajador_params)
        format.html { redirect_to @tipotrabajador, notice: 'Tipotrabajador was successfully updated.' }
        format.json { render :show, status: :ok, location: @tipotrabajador }
      else
        format.html { render :edit }
        format.json { render json: @tipotrabajador.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tipotrabajadors/1
  # DELETE /tipotrabajadors/1.json
  def destroy
    @tipotrabajador.destroy
    respond_to do |format|
      format.html { redirect_to tipotrabajadors_url, notice: 'Tipotrabajador was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tipotrabajador
      @tipotrabajador = Tipotrabajador.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tipotrabajador_params
      params.require(:tipotrabajador).permit(:code, :name)
    end
end
