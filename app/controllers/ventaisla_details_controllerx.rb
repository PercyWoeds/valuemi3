class VentaislaDetailsController < ApplicationController
  before_action :set_ventaisla_detail, only: [:show, :edit, :update, :destroy]

  # GET /ventaisla_details
  # GET /ventaisla_details.json
  def index
    @ventaisla_details = VentaislaDetail.all
  end

  # GET /ventaisla_details/1
  # GET /ventaisla_details/1.json
  def show
  end

  # GET /ventaisla_details/new
  def new
    @ventaisla_detail = VentaislaDetail.new
  end

  # GET /ventaisla_details/1/edit
  def edit
  end

  # POST /ventaisla_details
  # POST /ventaisla_details.json
  def create
    @ventaisla_detail = VentaislaDetail.new(ventaisla_detail_params)

    respond_to do |format|
      if @ventaisla_detail.save
        format.html { redirect_to @ventaisla_detail, notice: 'Ventaisla detail was successfully created.' }
        format.json { render :show, status: :created, location: @ventaisla_detail }
      else
        format.html { render :new }
        format.json { render json: @ventaisla_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ventaisla_details/1
  # PATCH/PUT /ventaisla_details/1.json
  def update
    respond_to do |format|
      if @ventaisla_detail.update(ventaisla_detail_params)
        format.html { redirect_to @ventaisla_detail, notice: 'Ventaisla detail was successfully updated.' }
        format.json { render :show, status: :ok, location: @ventaisla_detail }
      else
        format.html { render :edit }
        format.json { render json: @ventaisla_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ventaisla_details/1
  # DELETE /ventaisla_details/1.json
  def destroy
    @ventaisla_detail.destroy
    respond_to do |format|
      format.html { redirect_to ventaisla_details_url, notice: 'Ventaisla detail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ventaisla_detail
      @ventaisla_detail = VentaislaDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ventaisla_detail_params
      params.require(:ventaisla_detail).permit(:pump_id, :le_an_gln, :le_ac_gln, :price, :quantity, :total)
    end
end
