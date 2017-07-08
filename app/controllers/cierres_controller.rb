class CierresController < ApplicationController
  before_action :set_cierre, only: [:show, :edit, :update, :destroy]

  # GET /cierres
  # GET /cierres.json
  def index
    @cierres = Cierre.all
  end

  # GET /cierres/1
  # GET /cierres/1.json
  def show
  end

  # GET /cierres/new
  def new
    @cierre = Cierre.new
  end

  # GET /cierres/1/edit
  def edit
  end

  # POST /cierres
  # POST /cierres.json
  def create
    @cierre = Cierre.new(cierre_params)

    respond_to do |format|
      if @cierre.save
        format.html { redirect_to @cierre, notice: 'Cierre was successfully created.' }
        format.json { render :show, status: :created, location: @cierre }
      else
        format.html { render :new }
        format.json { render json: @cierre.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cierres/1
  # PATCH/PUT /cierres/1.json
  def update
    respond_to do |format|
      if @cierre.update(cierre_params)
        format.html { redirect_to @cierre, notice: 'Cierre was successfully updated.' }
        format.json { render :show, status: :ok, location: @cierre }
      else
        format.html { render :edit }
        format.json { render json: @cierre.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cierres/1
  # DELETE /cierres/1.json
  def destroy
    @cierre.destroy
    respond_to do |format|
      format.html { redirect_to cierres_url, notice: 'Cierre was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cierre
      @cierre = Cierre.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cierre_params
      params.require(:cierre).permit(:fecha, :descrip,:user_id)
    end
end
