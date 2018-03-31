class CreditosController < ApplicationController
  before_action :set_credito, only: [:show, :edit, :update, :destroy]

  # GET /creditos
  # GET /creditos.json
  def index
    @creditos = Credito.all
  end

  # GET /creditos/1
  # GET /creditos/1.json
  def show
  end

  # GET /creditos/new
  def new
    @credito = Credito.new
  end

  # GET /creditos/1/edit
  def edit
  end

  # POST /creditos
  # POST /creditos.json
  def create
    @credito = Credito.new(credito_params)

    respond_to do |format|
      if @credito.save
        format.html { redirect_to @credito, notice: 'Credito was successfully created.' }
        format.json { render :show, status: :created, location: @credito }
      else
        format.html { render :new }
        format.json { render json: @credito.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /creditos/1
  # PATCH/PUT /creditos/1.json
  def update
    respond_to do |format|
      if @credito.update(credito_params)
        format.html { redirect_to @credito, notice: 'Credito was successfully updated.' }
        format.json { render :show, status: :ok, location: @credito }
      else
        format.html { render :edit }
        format.json { render json: @credito.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /creditos/1
  # DELETE /creditos/1.json
  def destroy
    @credito.destroy
    respond_to do |format|
      format.html { redirect_to creditos_url, notice: 'Credito was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_credito
      @credito = Credito.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def credito_params
      params.require(:credito).permit(:code, :nombre)
    end
end
