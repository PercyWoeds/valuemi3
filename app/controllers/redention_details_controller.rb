class RedentionDetailsController < ApplicationController
  before_action :set_redention_detail, only: [:show, :edit, :update, :destroy]

  # GET /redention_details
  # GET /redention_details.json
  def index
    @redention_details = RedentionDetail.all
  end

  # GET /redention_details/1
  # GET /redention_details/1.json
  def show
  end

  # GET /redention_details/new
  def new
    @redention_detail = RedentionDetail.new
  end

  # GET /redention_details/1/edit
  def edit
  end

  # POST /redention_details
  # POST /redention_details.json
  def create
    @redention_detail = RedentionDetail.new(redention_detail_params)

    respond_to do |format|
      if @redention_detail.save
        format.html { redirect_to @redention_detail, notice: 'Redention detail was successfully created.' }
        format.json { render :show, status: :created, location: @redention_detail }
      else
        format.html { render :new }
        format.json { render json: @redention_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /redention_details/1
  # PATCH/PUT /redention_details/1.json
  def update
    respond_to do |format|
      if @redention_detail.update(redention_detail_params)
        format.html { redirect_to @redention_detail, notice: 'Redention detail was successfully updated.' }
        format.json { render :show, status: :ok, location: @redention_detail }
      else
        format.html { render :edit }
        format.json { render json: @redention_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /redention_details/1
  # DELETE /redention_details/1.json
  def destroy
    @redention_detail.destroy
    respond_to do |format|
      format.html { redirect_to redention_details_url, notice: 'Redention detail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_redention_detail
      @redention_detail = RedentionDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def redention_detail_params
      params.require(:redention_detail).permit(:factura_id, :product_id, :price, :quantity, :total, :discount)
    end
end
