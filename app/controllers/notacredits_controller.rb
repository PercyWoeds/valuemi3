class NotacreditsController < ApplicationController
  before_action :set_notacredit, only: [:show, :edit, :update, :destroy]

  # GET /notacredits
  # GET /notacredits.json
  def index
    @notacredits = Notacredit.all
  end

  # GET /notacredits/1
  # GET /notacredits/1.json
  def show
  end

  # GET /notacredits/new
  def new
    @notacredit = Notacredit.new
  end

  # GET /notacredits/1/edit
  def edit
  end

  # POST /notacredits
  # POST /notacredits.json
  def create
    @notacredit = Notacredit.new(notacredit_params)

    respond_to do |format|
      if @notacredit.save
        format.html { redirect_to @notacredit, notice: 'Notacredit was successfully created.' }
        format.json { render :show, status: :created, location: @notacredit }
      else
        format.html { render :new }
        format.json { render json: @notacredit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notacredits/1
  # PATCH/PUT /notacredits/1.json
  def update
    respond_to do |format|
      if @notacredit.update(notacredit_params)
        format.html { redirect_to @notacredit, notice: 'Notacredit was successfully updated.' }
        format.json { render :show, status: :ok, location: @notacredit }
      else
        format.html { render :edit }
        format.json { render json: @notacredit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notacredits/1
  # DELETE /notacredits/1.json
  def destroy
    @notacredit.destroy
    respond_to do |format|
      format.html { redirect_to notacredits_url, notice: 'Notacredit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notacredit
      @notacredit = Notacredit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def notacredit_params
      params.require(:notacredit).permit(:fecha, :code, :nota_id, :motivo, :subtotal, :tax, :total, :moneda_id, :mod_factura, :mod_tipo, :processed, :tipo, :description, :customer_id)
    end
end
