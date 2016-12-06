class ServicebuysController < ApplicationController
  before_action :set_servicebuy, only: [:show, :edit, :update, :destroy]

  # GET /servicebuys
  # GET /servicebuys.json
  def index
    @servicebuys = Servicebuy.all
  end

  # GET /servicebuys/1
  # GET /servicebuys/1.json
  def show
  end

  # GET /servicebuys/new
  def new
    @servicebuy = Servicebuy.new
  end

  # GET /servicebuys/1/edit
  def edit
  end

  # POST /servicebuys
  # POST /servicebuys.json
  def create
    @servicebuy = Servicebuy.new(servicebuy_params)

    respond_to do |format|
      if @servicebuy.save
        format.html { redirect_to @servicebuy, notice: 'Servicebuy was successfully created.' }
        format.json { render :show, status: :created, location: @servicebuy }
      else
        format.html { render :new }
        format.json { render json: @servicebuy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /servicebuys/1
  # PATCH/PUT /servicebuys/1.json
  def update
    respond_to do |format|
      if @servicebuy.update(servicebuy_params)
        format.html { redirect_to @servicebuy, notice: 'Servicebuy was successfully updated.' }
        format.json { render :show, status: :ok, location: @servicebuy }
      else
        format.html { render :edit }
        format.json { render json: @servicebuy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /servicebuys/1
  # DELETE /servicebuys/1.json
  def destroy
    @servicebuy.destroy
    respond_to do |format|
      format.html { redirect_to servicebuys_url, notice: 'Servicebuy was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_servicebuy
      @servicebuy = Servicebuy.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def servicebuy_params
      params.require(:servicebuy).permit(:code, :name, :cost, :price, :tax1_name, :tax1, :tax2_name, :tax2, :tax3_name, :tax3, :quantity, :description, :comments, :company_id, :discount, :currtotal, :i, :total)
    end
end
