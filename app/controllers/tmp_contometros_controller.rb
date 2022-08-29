class TmpContometrosController < ApplicationController
  before_action :set_tmp_contometro, only: [:show, :edit, :update, :destroy]

  # GET /tmp_contometros
  # GET /tmp_contometros.json
  def index
    @tmp_contometros = TmpContometro.all
  end

  # GET /tmp_contometros/1
  # GET /tmp_contometros/1.json
  def show
  end

  # GET /tmp_contometros/new
  def new
    @tmp_contometro = TmpContometro.new
  end

  # GET /tmp_contometros/1/edit
  def edit
  end

  # POST /tmp_contometros
  # POST /tmp_contometros.json
  def create
    @tmp_contometro = TmpContometro.new(tmp_contometro_params)

    respond_to do |format|
      if @tmp_contometro.save
        format.html { redirect_to @tmp_contometro, notice: 'Tmp contometro was successfully created.' }
        format.json { render :show, status: :created, location: @tmp_contometro }
      else
        format.html { render :new }
        format.json { render json: @tmp_contometro.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tmp_contometros/1
  # PATCH/PUT /tmp_contometros/1.json
  def update
    respond_to do |format|
      if @tmp_contometro.update(tmp_contometro_params)
        format.html { redirect_to @tmp_contometro, notice: 'Tmp contometro was successfully updated.' }
        format.json { render :show, status: :ok, location: @tmp_contometro }
      else
        format.html { render :edit }
        format.json { render json: @tmp_contometro.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tmp_contometros/1
  # DELETE /tmp_contometros/1.json
  def destroy
    @tmp_contometro.destroy
    respond_to do |format|
      format.html { redirect_to tmp_contometros_url, notice: 'Tmp contometro was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tmp_contometro
      @tmp_contometro = TmpContometro.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tmp_contometro_params
      params.require(:tmp_contometro).permit(:nid_cierreturno, :nid_surtidor, :nid_mangueras, :nid_producto, :nid_tanque, :dprecio_producto, :dcontometroinicial_manguera, :dcontometroactual_manguera, :dtotgalvendido_manguera, :dimporte, :dnocontabilizado_manguera, :dstockactual, :ffechaproceso_cierreturno)
    end
end
