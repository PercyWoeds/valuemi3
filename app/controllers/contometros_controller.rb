class ContometrosController < ApplicationController
  before_action :set_contometro, only: [:show, :edit, :update, :destroy]

  # GET /contometros
  # GET /contometros.json
  def index
    @contometros = Contometro.paginate(:page => params[:page])


  end

  # GET /contometros/1
  # GET /contometros/1.json
  def show
  end

  # GET /contometros/new
  def new
    @contometro = Contometro.new
  end

  # GET /contometros/1/edit
  def edit
  end

  # POST /contometros
  # POST /contometros.json
  def create
    @contometro = Contometro.new(contometro_params)

    respond_to do |format|
      if @contometro.save
        format.html { redirect_to @contometro, notice: 'Contometro was successfully created.' }
        format.json { render :show, status: :created, location: @contometro }
      else
        format.html { render :new }
        format.json { render json: @contometro.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contometros/1
  # PATCH/PUT /contometros/1.json
  def update
    respond_to do |format|
      if @contometro.update(contometro_params)
        format.html { redirect_to @contometro, notice: 'Contometro was successfully updated.' }
        format.json { render :show, status: :ok, location: @contometro }
      else
        format.html { render :edit }
        format.json { render json: @contometro.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contometros/1
  # DELETE /contometros/1.json
  def destroy
    @contometro.destroy
    respond_to do |format|
      format.html { redirect_to contometros_url, notice: 'Contometro was successfully destroyed.' }
      format.json { head :no_content }
    end
  end



 def import
      Contometro.import(params[:file])
       redirect_to root_url, notice: "Contometro importados."
  end 
 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contometro
      @contometro = Contometro.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contometro_params
      params.require(:contometro).permit(:nid_cierreturno, :nid_surtidor, :nid_mangueras, :nid_producto, :nid_tanque, :dprecio_producto, :dcontometroinicial_manguera, :dcontometroactual_manguera, :dtotgalvendido_manguera, :dimporte, :dnocontabilizado_manguera, :dstockactual, :ffechaproceso_cierreturno)
    end
end
