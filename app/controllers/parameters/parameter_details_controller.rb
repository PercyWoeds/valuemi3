class Parameters::ParameterDetailsController < ApplicationController

  before_action :set_parameter
  
  before_action :set_parameter_detail, :except=> [:new,:create]

  # GET /parameter_details
  # GET /parameter_details.json
  def index
    @parameter_details = ParameterDetail.all
  end

  # GET /parameter_details/1
  # GET /parameter_details/1.json
  def show
  end

  # GET /parameter_details/new
  def new
    @parameter_detail = ParameterDetail.new
    @afps= Afp.all 
  end

  # GET /parameter_details/1/edit
  def edit
    @parameter = Afp.find(@parameter_detail.afp_id)
  end

  # POST /parameter_details
  # POST /parameter_details.json
  def create
    @afps= Afp.all 
    @parameter_detail = ParameterDetail.new(parameter_detail_params)
    @parameter_detail.parameter_id  = @parameter.id 
    respond_to do |format|
      if @parameter_detail.save
        format.html { redirect_to @parameter, notice: 'Parameter detail was successfully created.' }
        format.json { render :show, status: :created, location: @parameter }
      else
        format.html { render :new }
        format.json { render json: @parameter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /parameter_details/1
  # PATCH/PUT /parameter_details/1.json
  def update
    
    
    
    respond_to do |format|
      if @parameter_detail.update(parameter_detail_params)
        format.html { redirect_to @parameter, notice: 'Parameter detail was successfully updated.' }
        format.json { render :show, status: :ok, location: @parameter }
      else
        format.html { render :edit }
        format.json { render json: @parameter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /parameter_details/1
  # DELETE /parameter_details/1.json
  def destroy
    @parameter_detail.destroy
    respond_to do |format|
      format.html { redirect_to parameter_details_url, notice: 'Parameter detail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
     def set_parameter 
      @parameter = Parameter.find(params[:parameter_id])
    end 
    
    def set_parameter_detail
      @parameter_detail = ParameterDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def parameter_detail_params
      params.require(:parameter_detail).permit(:parameter_id, :afp_id, :aporte, :seguro, :comision)
    end
end
