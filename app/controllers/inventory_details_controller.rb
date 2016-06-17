class InventoryDetailsController < ApplicationController
  before_action :set_inventory_detail, only: [:show, :edit, :update, :destroy]

  # GET /inventory_details
  # GET /inventory_details.json
  def index
    @inventory_details = InventoryDetail.all
  end

  # GET /inventory_details/1
  # GET /inventory_details/1.json
  def show
  end

  # GET /inventory_details/new
  def new
    @inventory_detail = InventoryDetail.new
  end

  # GET /inventory_details/1/edit
  def edit
  end

  # POST /inventory_details
  # POST /inventory_details.json
  def create
    @inventory_detail = InventoryDetail.new(inventory_detail_params)

    respond_to do |format|
      if @inventory_detail.save
        format.html { redirect_to @inventory_detail, notice: 'Inventory detail was successfully created.' }
        format.json { render :show, status: :created, location: @inventory_detail }
      else
        format.html { render :new }
        format.json { render json: @inventory_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /inventory_details/1
  # PATCH/PUT /inventory_details/1.json
  def update
    respond_to do |format|
      if @inventory_detail.update(inventory_detail_params)
        format.html { redirect_to @inventory_detail, notice: 'Inventory detail was successfully updated.' }
        format.json { render :show, status: :ok, location: @inventory_detail }
      else
        format.html { render :edit }
        format.json { render json: @inventory_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inventory_details/1
  # DELETE /inventory_details/1.json
  def destroy
    @inventory_detail.destroy
    respond_to do |format|
      format.html { redirect_to inventory_details_url, notice: 'Inventory detail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_inventory_detail
      @inventory_detail = InventoryDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def inventory_detail_params
      params.require(:inventory_detail).permit(:product_id, :cost, :logical, :phisycal, :comments)
    end
end
