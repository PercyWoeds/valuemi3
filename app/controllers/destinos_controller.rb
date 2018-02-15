class DestinosController < ApplicationController
  before_action :set_destino, only: [:show, :edit, :update, :destroy]

  # GET /destinos
  # GET /destinos.json
  def index
    @destinos = Destino.all
  end

  # GET /destinos/1
  # GET /destinos/1.json
  def show
  end

  # GET /destinos/new
  def new
    @destino = Destino.new
  end

  # GET /destinos/1/edit
  def edit
  end

  # POST /destinos
  # POST /destinos.json
  def create
    @destino = Destino.new(destino_params)

    respond_to do |format|
      if @destino.save
        format.html { redirect_to @destino, notice: 'Destino was successfully created.' }
        format.json { render :show, status: :created, location: @destino }
      else
        format.html { render :new }
        format.json { render json: @destino.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /destinos/1
  # PATCH/PUT /destinos/1.json
  def update
    respond_to do |format|
      if @destino.update(destino_params)
        format.html { redirect_to @destino, notice: 'Destino was successfully updated.' }
        format.json { render :show, status: :ok, location: @destino }
      else
        format.html { render :edit }
        format.json { render json: @destino.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /destinos/1
  # DELETE /destinos/1.json
  def destroy
    @destino.destroy
    respond_to do |format|
      format.html { redirect_to destinos_url, notice: 'Destino was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_destino
      @destino = Destino.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def destino_params
      params.require(:destino).permit(:code, :name)
    end
end
