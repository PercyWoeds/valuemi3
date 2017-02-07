class UbicasController < ApplicationController
  before_action :set_ubica, only: [:show, :edit, :update, :destroy]

  # GET /ubicas
  # GET /ubicas.json
  def index
    @ubicas = Ubica.all
  end

  # GET /ubicas/1
  # GET /ubicas/1.json
  def show
  end

  # GET /ubicas/new
  def new
    @ubica = Ubica.new
  end

  # GET /ubicas/1/edit
  def edit
  end

  # POST /ubicas
  # POST /ubicas.json
  def create
    @ubica = Ubica.new(ubica_params)

    respond_to do |format|
      if @ubica.save
        format.html { redirect_to @ubica, notice: 'Ubica was successfully created.' }
        format.json { render :show, status: :created, location: @ubica }
      else
        format.html { render :new }
        format.json { render json: @ubica.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ubicas/1
  # PATCH/PUT /ubicas/1.json
  def update
    respond_to do |format|
      if @ubica.update(ubica_params)
        format.html { redirect_to @ubica, notice: 'Ubica was successfully updated.' }
        format.json { render :show, status: :ok, location: @ubica }
      else
        format.html { render :edit }
        format.json { render json: @ubica.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ubicas/1
  # DELETE /ubicas/1.json
  def destroy
    @ubica.destroy
    respond_to do |format|
      format.html { redirect_to ubicas_url, notice: 'Ubica was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ubica
      @ubica = Ubica.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ubica_params
      params.require(:ubica).permit(:descrip, :comments)
    end
end
