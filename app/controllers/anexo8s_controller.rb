class Anexo8sController < ApplicationController
  before_action :set_anexo8, only: [:show, :edit, :update, :destroy]

  # GET /anexo8s
  # GET /anexo8s.json
  def index
    @anexo8s = Anexo8.all
  end

  # GET /anexo8s/1
  # GET /anexo8s/1.json
  def show
  end

  # GET /anexo8s/new
  def new
    @anexo8 = Anexo8.new
  end

  # GET /anexo8s/1/edit
  def edit
  end

  # POST /anexo8s
  # POST /anexo8s.json
  def create
    @anexo8 = Anexo8.new(anexo8_params)

    respond_to do |format|
      if @anexo8.save
        format.html { redirect_to @anexo8, notice: 'Anexo8 was successfully created.' }
        format.json { render :show, status: :created, location: @anexo8 }
      else
        format.html { render :new }
        format.json { render json: @anexo8.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /anexo8s/1
  # PATCH/PUT /anexo8s/1.json
  def update
    respond_to do |format|
      if @anexo8.update(anexo8_params)
        format.html { redirect_to @anexo8, notice: 'Anexo8 was successfully updated.' }
        format.json { render :show, status: :ok, location: @anexo8 }
      else
        format.html { render :edit }
        format.json { render json: @anexo8.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /anexo8s/1
  # DELETE /anexo8s/1.json
  def destroy
    @anexo8.destroy
    respond_to do |format|
      format.html { redirect_to anexo8s_url, notice: 'Anexo8 was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_anexo8
      @anexo8 = Anexo8.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def anexo8_params
      params.require(:anexo8).permit(:code, :name, :code_nube,:tipo)
    end
end
