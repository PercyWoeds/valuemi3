class CegresosController < ApplicationController
  before_action :set_cegreso, only: [:show, :edit, :update, :destroy]

  # GET /cegresos
  # GET /cegresos.json
  def index
    @cegresos = Cegreso.all
  end

  # GET /cegresos/1
  # GET /cegresos/1.json
  def show
  end

  # GET /cegresos/new
  def new
    @cegreso = Cegreso.new
  end

  # GET /cegresos/1/edit
  def edit
  end

  # POST /cegresos
  # POST /cegresos.json
  def create
    @cegreso = Cegreso.new(cegreso_params)

    respond_to do |format|
      if @cegreso.save
        format.html { redirect_to @cegreso, notice: 'Cegreso was successfully created.' }
        format.json { render :show, status: :created, location: @cegreso }
      else
        format.html { render :new }
        format.json { render json: @cegreso.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cegresos/1
  # PATCH/PUT /cegresos/1.json
  def update
    respond_to do |format|
      if @cegreso.update(cegreso_params)
        format.html { redirect_to @cegreso, notice: 'Cegreso was successfully updated.' }
        format.json { render :show, status: :ok, location: @cegreso }
      else
        format.html { render :edit }
        format.json { render json: @cegreso.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cegresos/1
  # DELETE /cegresos/1.json
  def destroy
    @cegreso.destroy
    respond_to do |format|
      format.html { redirect_to cegresos_url, notice: 'Cegreso was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cegreso
      @cegreso = Cegreso.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cegreso_params
      params.require(:cegreso).permit(:employee_id, :transportorder_id, :fecha1, :fecha2, :observa, :descrip, :importe, :moneda_id)
    end
end
