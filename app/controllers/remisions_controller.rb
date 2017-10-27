class RemisionsController < ApplicationController
  before_action :set_remision, only: [:show, :edit, :update, :destroy]

  # GET /remisions
  # GET /remisions.json
  def index
    @remisions = Remision.all
  end

  # GET /remisions/1
  # GET /remisions/1.json
  def show
  end

  # GET /remisions/new
  def new
    @remision = Remision.new
  end

  # GET /remisions/1/edit
  def edit
  end

  # POST /remisions
  # POST /remisions.json
  def create
    @remision = Remision.new(remision_params)

    respond_to do |format|
      if @remision.save
        format.html { redirect_to @remision, notice: 'Remision was successfully created.' }
        format.json { render :show, status: :created, location: @remision }
      else
        format.html { render :new }
        format.json { render json: @remision.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /remisions/1
  # PATCH/PUT /remisions/1.json
  def update
    respond_to do |format|
      if @remision.update(remision_params)
        format.html { redirect_to @remision, notice: 'Remision was successfully updated.' }
        format.json { render :show, status: :ok, location: @remision }
      else
        format.html { render :edit }
        format.json { render json: @remision.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /remisions/1
  # DELETE /remisions/1.json
  def destroy
    @remision.destroy
    respond_to do |format|
      format.html { redirect_to remisions_url, notice: 'Remision was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_remision
      @remision = Remision.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def remision_params
      params.require(:remision).permit(:code, :name)
    end
end
