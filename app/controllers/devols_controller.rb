class DevolsController < ApplicationController
  before_action :set_devol, only: [:show, :edit, :update, :destroy]

  # GET /devols
  # GET /devols.json
  def index
    @devols = Devol.all
  end

  # GET /devols/1
  # GET /devols/1.json
  def show
  end

  # GET /devols/new
  def new
    @devol = Devol.new
    @products = Product.where(products_category_id: 1 )

  end

  # GET /devols/1/edit
  def edit
    @products = Product.where(products_category_id: 1 )

  end

  # POST /devols
  # POST /devols.json
  def create
    @devol = Devol.new(devol_params)
    @products = Product.where(products_category_id: 1 )

    respond_to do |format|
      if @devol.save
        format.html { redirect_to @devol, notice: 'Devol was successfully created.' }
        format.json { render :show, status: :created, location: @devol }
      else
        format.html { render :new }
        format.json { render json: @devol.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /devols/1
  # PATCH/PUT /devols/1.json
  def update
    respond_to do |format|
      if @devol.update(devol_params)
        format.html { redirect_to @devol, notice: 'Devol was successfully updated.' }
        format.json { render :show, status: :ok, location: @devol }
      else
        format.html { render :edit }
        format.json { render json: @devol.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /devols/1
  # DELETE /devols/1.json
  def destroy
    @devol.destroy
    respond_to do |format|
      format.html { redirect_to devols_url, notice: 'Devol was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_devol
      @devol = Devol.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def devol_params
      params.require(:devol).permit(:cod_prod, :fecha, :documento, :observa,:qty  )
    end
end
