class TanquesController < ApplicationController
  before_action :set_tanque, only: [:show, :edit, :update, :destroy]

  # GET /tanques
  # GET /tanques.json
  def index
    @tanques = Tanque.all
  end

  # GET /tanques/1
  # GET /tanques/1.json
  def show
    @products = Product.where(products_category_id: 1)
  end

  # GET /tanques/new
  def new
    @tanque = Tanque.new
    @products = Product.where(products_category_id: 1)
    
  end

  # GET /tanques/1/edit
  def edit
    @products = Product.where(products_category_id: 1)
  end

  # POST /tanques
  # POST /tanques.json
  def create
    @tanque = Tanque.new(tanque_params)
  @products = Product.where(products_category_id: 1)
    respond_to do |format|
      if @tanque.save
        format.html { redirect_to @tanque, notice: 'Tanque was successfully created.' }
        format.json { render :show, status: :created, location: @tanque }
      else
        format.html { render :new }
        format.json { render json: @tanque.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tanques/1
  # PATCH/PUT /tanques/1.json
  def update
    respond_to do |format|
      if @tanque.update(tanque_params)
        format.html { redirect_to @tanque, notice: 'Tanque was successfully updated.' }
        format.json { render :show, status: :ok, location: @tanque }
      else
        format.html { render :edit }
        format.json { render json: @tanque.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tanques/1
  # DELETE /tanques/1.json
  def destroy
    @tanque.destroy
    respond_to do |format|
      format.html { redirect_to tanques_url, notice: 'Tanque was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tanque
      @tanque = Tanque.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tanque_params
      params.require(:tanque).permit(:code, :product_id, :saldo_inicial, :varilla)
    end
end
