class TipomovsController < ApplicationController
  before_action :set_tipomov, only: [:show, :edit, :update, :destroy]

  # GET /tipomovs
  # GET /tipomovs.json
  def index
    @tipomovs = Tipomov.all
  end

  # GET /tipomovs/1
  # GET /tipomovs/1.json
  def show
  end

  # GET /tipomovs/new
  def new
    @tipomov = Tipomov.new
  end

  # GET /tipomovs/1/edit
  def edit
  end

  # POST /tipomovs
  # POST /tipomovs.json
  def create
    @tipomov = Tipomov.new(tipomov_params)

    respond_to do |format|
      if @tipomov.save
        format.html { redirect_to @tipomov, notice: 'Tipomov was successfully created.' }
        format.json { render :show, status: :created, location: @tipomov }
      else
        format.html { render :new }
        format.json { render json: @tipomov.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tipomovs/1
  # PATCH/PUT /tipomovs/1.json
  def update
    respond_to do |format|
      if @tipomov.update(tipomov_params)
        format.html { redirect_to @tipomov, notice: 'Tipomov was successfully updated.' }
        format.json { render :show, status: :ok, location: @tipomov }
      else
        format.html { render :edit }
        format.json { render json: @tipomov.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tipomovs/1
  # DELETE /tipomovs/1.json
  def destroy
    @tipomov.destroy
    respond_to do |format|
      format.html { redirect_to tipomovs_url, notice: 'Tipomov was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tipomov
      @tipomov = Tipomov.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tipomov_params
      params.require(:tipomov).permit(:code, :descrip)
    end
end
