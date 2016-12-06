class InstruccionsController < ApplicationController
  before_action :set_instruccion, only: [:show, :edit, :update, :destroy]

  # GET /instruccions
  # GET /instruccions.json
  def index
    @instruccions = Instruccion.all
  end

  # GET /instruccions/1
  # GET /instruccions/1.json
  def show
  end

  # GET /instruccions/new
  def new
    @instruccion = Instruccion.new
  end

  # GET /instruccions/1/edit
  def edit
  end

  # POST /instruccions
  # POST /instruccions.json
  def create
    @instruccion = Instruccion.new(instruccion_params)

    respond_to do |format|
      if @instruccion.save
        format.html { redirect_to @instruccion, notice: 'Instruccion was successfully created.' }
        format.json { render :show, status: :created, location: @instruccion }
      else
        format.html { render :new }
        format.json { render json: @instruccion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /instruccions/1
  # PATCH/PUT /instruccions/1.json
  def update
    respond_to do |format|
      if @instruccion.update(instruccion_params)
        format.html { redirect_to @instruccion, notice: 'Instruccion was successfully updated.' }
        format.json { render :show, status: :ok, location: @instruccion }
      else
        format.html { render :edit }
        format.json { render json: @instruccion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /instruccions/1
  # DELETE /instruccions/1.json
  def destroy
    @instruccion.destroy
    respond_to do |format|
      format.html { redirect_to instruccions_url, notice: 'Instruccion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_instruccion
      @instruccion = Instruccion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def instruccion_params
      params.require(:instruccion).permit(:description1, :description2, :description3, :description4)
    end
end
