class CcostosController < ApplicationController
  before_action :set_ccosto, only: [:show, :edit, :update, :destroy]

  # GET /ccostos
  # GET /ccostos.json
  def index
    @ccostos = Ccosto.all
  end

  # GET /ccostos/1
  # GET /ccostos/1.json
  def show
  end

  # GET /ccostos/new
  def new
    @ccosto = Ccosto.new
  end

  # GET /ccostos/1/edit
  def edit
  end

  # POST /ccostos
  # POST /ccostos.json
  def create
    @ccosto = Ccosto.new(ccosto_params)

    respond_to do |format|
      if @ccosto.save
        format.html { redirect_to @ccosto, notice: 'Ccosto was successfully created.' }
        format.json { render :show, status: :created, location: @ccosto }
      else
        format.html { render :new }
        format.json { render json: @ccosto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ccostos/1
  # PATCH/PUT /ccostos/1.json
  def update
    respond_to do |format|
      if @ccosto.update(ccosto_params)
        format.html { redirect_to @ccosto, notice: 'Ccosto was successfully updated.' }
        format.json { render :show, status: :ok, location: @ccosto }
      else
        format.html { render :edit }
        format.json { render json: @ccosto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ccostos/1
  # DELETE /ccostos/1.json
  def destroy
    @ccosto.destroy
    respond_to do |format|
      format.html { redirect_to ccostos_url, notice: 'Ccosto was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ccosto
      @ccosto = Ccosto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ccosto_params
      params.require(:ccosto).permit(:code, :name, :comments)
    end
end
