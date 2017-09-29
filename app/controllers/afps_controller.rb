class AfpsController < ApplicationController
  before_action :set_afp, only: [:show, :edit, :update, :destroy]

  # GET /afps
  # GET /afps.json
  def index
    @afps = Afp.all
  end

  # GET /afps/1
  # GET /afps/1.json
  def show
  end

  # GET /afps/new
  def new
    @afp = Afp.new
  end

  # GET /afps/1/edit
  def edit
  end

  # POST /afps
  # POST /afps.json
  def create
    @afp = Afp.new(afp_params)

    respond_to do |format|
      if @afp.save
        format.html { redirect_to @afp, notice: 'Afp was successfully created.' }
        format.json { render :show, status: :created, location: @afp }
      else
        format.html { render :new }
        format.json { render json: @afp.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /afps/1
  # PATCH/PUT /afps/1.json
  def update
    respond_to do |format|
      if @afp.update(afp_params)
        format.html { redirect_to @afp, notice: 'Afp was successfully updated.' }
        format.json { render :show, status: :ok, location: @afp }
      else
        format.html { render :edit }
        format.json { render json: @afp.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /afps/1
  # DELETE /afps/1.json
  def destroy
    @afp.destroy
    respond_to do |format|
      format.html { redirect_to afps_url, notice: 'Afp was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_afp
      @afp = Afp.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def afp_params
      params.require(:afp).permit(:name, :company_id)
    end
end
