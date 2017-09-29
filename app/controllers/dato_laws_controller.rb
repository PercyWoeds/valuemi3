class DatoLawsController < ApplicationController
  before_action :set_dato_law, only: [:show, :edit, :update, :destroy]

  # GET /dato_laws
  # GET /dato_laws.json
  def index
    @dato_laws = DatoLaw.all
  end

  # GET /dato_laws/1
  # GET /dato_laws/1.json
  def show
  end

  # GET /dato_laws/new
  def new
    @dato_law = DatoLaw.new
  end

  # GET /dato_laws/1/edit
  def edit
  end

  # POST /dato_laws
  # POST /dato_laws.json
  def create
    @dato_law = DatoLaw.new(dato_law_params)

    respond_to do |format|
      if @dato_law.save
        format.html { redirect_to @dato_law, notice: 'Dato law was successfully created.' }
        format.json { render :show, status: :created, location: @dato_law }
      else
        format.html { render :new }
        format.json { render json: @dato_law.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dato_laws/1
  # PATCH/PUT /dato_laws/1.json
  def update
    respond_to do |format|
      if @dato_law.update(dato_law_params)
        format.html { redirect_to @dato_law, notice: 'Dato law was successfully updated.' }
        format.json { render :show, status: :ok, location: @dato_law }
      else
        format.html { render :edit }
        format.json { render json: @dato_law.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dato_laws/1
  # DELETE /dato_laws/1.json
  def destroy
    @dato_law.destroy
    respond_to do |format|
      format.html { redirect_to dato_laws_url, notice: 'Dato law was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dato_law
      @dato_law = DatoLaw.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dato_law_params
      params.require(:dato_law).permit(:employee_id, :sueldo_integral, :comision, :descuento_ley, :afp_id, :ies, :senati, :sobretiempo, :otra_ley_social, :accidente_trabajo, :descuento_quinta, :domiciliado, :a_familiar, :no_afecto, :no_afecto_grati, :no_afecto_afp, :cussp, :tipo_afiliado_id, :regimen_id, :contrato_inicio, :contrato_fin, :vacaciones_inicio, :vacaciones_fin, :grati_julio, :grati_diciembre, :importe_subsidio)
    end
end
