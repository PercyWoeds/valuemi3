class SubcontratsController < ApplicationController
  before_action :set_subcontrat, only: [:show, :edit, :update, :destroy]

  # GET /subcontrats
  # GET /subcontrats.json
  def index
    @subcontrats = Subcontrat.all
  end

  # GET /subcontrats/1
  # GET /subcontrats/1.json
  def show
  end

  # GET /subcontrats/new
  def new
    @subcontrat = Subcontrat.new
  end

  # GET /subcontrats/1/edit
  def edit
  end

  # POST /subcontrats
  # POST /subcontrats.json
  def create
    @subcontrat = Subcontrat.new(subcontrat_params)

    respond_to do |format|
      if @subcontrat.save
        format.html { redirect_to @subcontrat, notice: 'Subcontrat was successfully created.' }
        format.json { render :show, status: :created, location: @subcontrat }
      else
        format.html { render :new }
        format.json { render json: @subcontrat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subcontrats/1
  # PATCH/PUT /subcontrats/1.json
  def update
    respond_to do |format|
      if @subcontrat.update(subcontrat_params)
        format.html { redirect_to @subcontrat, notice: 'Subcontrat was successfully updated.' }
        format.json { render :show, status: :ok, location: @subcontrat }
      else
        format.html { render :edit }
        format.json { render json: @subcontrat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subcontrats/1
  # DELETE /subcontrats/1.json
  def destroy
    @subcontrat.destroy
    respond_to do |format|
      format.html { redirect_to subcontrats_url, notice: 'Subcontrat was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subcontrat
      @subcontrat = Subcontrat.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subcontrat_params
      params.require(:subcontrat).permit(:ruc, :name, :address1, :distrito, :provincia, :dpto, :pais)
    end
end
