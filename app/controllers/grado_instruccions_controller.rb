class GradoInstruccionsController < ApplicationController
  before_action :set_grado_instruccion, only: [:show, :edit, :update, :destroy]

  # GET /grado_instruccions
  # GET /grado_instruccions.json
  def index
    @grado_instruccions = GradoInstruccion.all
  end

  # GET /grado_instruccions/1
  # GET /grado_instruccions/1.json
  def show
  end

  # GET /grado_instruccions/new
  def new
    @grado_instruccion = GradoInstruccion.new
  end

  # GET /grado_instruccions/1/edit
  def edit
  end

  # POST /grado_instruccions
  # POST /grado_instruccions.json
  def create
    @grado_instruccion = GradoInstruccion.new(grado_instruccion_params)

    respond_to do |format|
      if @grado_instruccion.save
        format.html { redirect_to @grado_instruccion, notice: 'Grado instruccion was successfully created.' }
        format.json { render :show, status: :created, location: @grado_instruccion }
      else
        format.html { render :new }
        format.json { render json: @grado_instruccion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /grado_instruccions/1
  # PATCH/PUT /grado_instruccions/1.json
  def update
    respond_to do |format|
      if @grado_instruccion.update(grado_instruccion_params)
        format.html { redirect_to @grado_instruccion, notice: 'Grado instruccion was successfully updated.' }
        format.json { render :show, status: :ok, location: @grado_instruccion }
      else
        format.html { render :edit }
        format.json { render json: @grado_instruccion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /grado_instruccions/1
  # DELETE /grado_instruccions/1.json
  def destroy
    @grado_instruccion.destroy
    respond_to do |format|
      format.html { redirect_to grado_instruccions_url, notice: 'Grado instruccion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_grado_instruccion
      @grado_instruccion = GradoInstruccion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def grado_instruccion_params
      params.require(:grado_instruccion).permit(:code, :name)
    end
end
